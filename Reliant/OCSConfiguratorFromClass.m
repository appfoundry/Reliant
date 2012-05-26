//
//  OCSConfiguratorFromClass.m
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.



#import "OCSConfiguratorFromClass.h"
#import "OCSConfiguratorBase+ForSubclassEyesOnly.h"

#import <objc/runtime.h>

#import "OCSConfiguratorConstants.h"
#import "OCSApplicationContext.h"
#import "OCSDefinition.h"
#import "OCSSingletonScope.h"
#import "OCSSwizzler.h"

/**
 Configurator private category. Holds private ivars and methods.
 */
@interface OCSConfiguratorFromClass () {
    /**
     A reference to the configurator instance.
     @see OCSConfiguratorFromClass
     */
    id _configInstance;
}


/**
 Create an object instance for the given key. This method will delegate to the configurator class.
 
 @param key the key
 
 @return the object for the given key. Returns nil while still initializing or when the object for the given key was not found.
 */
- (id) _createObjectInstanceForKey:(NSString *) key;

- (void) _registerAliasesForDefinition:(OCSDefinition *) definition;


@end

@implementation OCSConfiguratorFromClass


- (id)initWithClass:(Class) factoryClass
{
    self = [super init];
    if (self) {
        _configInstance = createExtendedConfiguratorInstance(factoryClass, ^(NSString *name) {
            BOOL result = ([name hasPrefix:LAZY_SINGLETON_PREFIX] || [name hasPrefix:EAGER_SINGLETON_PREFIX]);
            return result;
        });
        unsigned int count;
        Method * methods = class_copyMethodList(factoryClass, &count);
        if (count > 0) {
            for (int i = 0; i < count; i++) {
                SEL selector = method_getName(methods[i]);
                const char* methodName = sel_getName(selector);
                NSString *objcStringName = [NSString  stringWithCString:methodName encoding:NSUTF8StringEncoding];
                unsigned int paramCount = method_getNumberOfArguments(methods[i]);
                NSLog(@"Method %@ with %d arguments found", objcStringName, paramCount);
                if ([objcStringName hasPrefix:@"create"] &&  paramCount == 2) {
                    OCSDefinition *def = [[OCSDefinition alloc] init];
                    //TODO put more info on definition
                    NSUInteger offset = 0;
                    if ([objcStringName hasPrefix:LAZY_SINGLETON_PREFIX]) {
                        def.singleton = YES;
                        def.lazy = YES;
                        offset = LAZY_SINGLETON_PREFIX.length;
                    } else if ([objcStringName hasPrefix:EAGER_SINGLETON_PREFIX]) {
                        def.singleton = YES;
                        def.lazy = NO;
                        offset = EAGER_SINGLETON_PREFIX.length;
                    } else if ([objcStringName hasPrefix:PROTOTYPE_PREFIX]) {
                        def.singleton = NO;
                        offset = PROTOTYPE_PREFIX.length;
                    }
                    
                    if (offset) {
                        NSLog(@"Registering definition %@", def);
                        NSString *key = [objcStringName substringFromIndex:offset];
                        if (key.length > 0) {
                            def.key = key;
                            [self _registerAliasesForDefinition:def];
                            [self registerDefinition:def];
                        }
                    } else {
                        NSLog(@"Create method found, but not as expected, ignoring it (%@)", objcStringName);
                    }
                    [def release];
                } else {
                    NSLog(@"Ignoring non-create method (%@)", objcStringName);
                }
            }
        } else {
            NSLog(@"No methods found on class...");
        }
        free(methods);
    }
    return self;
}




- (id) _createObjectInstanceForKey:(NSString *) key {
    OCSDefinition *definition = [self definitionForKeyOrAlias:key];
    id result = nil;
    if (definition) {
        NSString *methodPrefix = definition.singleton ? (definition.lazy ? LAZY_SINGLETON_PREFIX : EAGER_SINGLETON_PREFIX) : PROTOTYPE_PREFIX;
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", methodPrefix, key]);
        if ([_configInstance respondsToSelector:selector]) {
            result = [_configInstance performSelector:selector];
        }
    }
    
    return result;
}

- (void) _registerAliasesForDefinition:(OCSDefinition *) definition
{
    NSString *key = definition.key;
    
    //Alias where all letters are upper cased
    [definition addAlias:[key uppercaseString]];
    //Alias where first letter is lower case
    [definition addAlias:[key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[key substringWithRange:NSMakeRange(0, 1)] lowercaseString]]];

    
    NSString *aliasMethodName = [NSString stringWithFormat:@"%@%@", ALIAS_METHOD_PREFIX, key];
    Method aliasMethod = class_getInstanceMethod([_configInstance class], NSSelectorFromString(aliasMethodName));
    if (aliasMethod) {
        id aliases = method_invoke(_configInstance, aliasMethod);
        if (![aliases isKindOfClass:[NSArray class]]) {
            [NSException raise:@"OCSConfiguratorException" format:@"Method %@ should return an NSArray or a subclass of it", aliasMethodName];
            
            return;
        }
        
        [aliases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![obj isKindOfClass:[NSString class]]) {
                [NSException raise:@"OCSConfiguratorException" format:@"Method %@ should return an NSArray or a subclass of it, containing only NSString objects or a subclass of it", aliasMethodName];
            }
            
            [definition addAlias:obj]; 
        }];
    }
}


- (id) internalObjectForKey:(NSString *)keyOrAlias inContext:(OCSApplicationContext *)context {
    OCSDefinition *definition = [self definitionForKeyOrAlias:keyOrAlias];
    id result = nil;
    if (definition) {
        //If singleton, check if we already have it in our registry. If not load it and put it there.
        //DO NOT do anything different for lazy or eager singletons. If demanded, we must always load!
        if (definition.singleton) {
            //TODO since the configurator class is extended, does the singleton sope make sence here. Shouldn't we use it in the dynamic subclass instead?
            result = [[OCSSingletonScope sharedOCSSingletonScope] objectForKey:definition.key];
            if (result == nil) {
                result = [self _createObjectInstanceForKey:definition.key];
                
                [[OCSSingletonScope sharedOCSSingletonScope] registerObject:result forKey:definition.key];
                
                //If we are still initializing, postpone the injection process
                //Ohterwise we can do injection.
                if (!self.initializing) {
                    [context performInjectionOn:result];
                }
            }
        } else {
            result = [self _createObjectInstanceForKey:definition.key];
            
            [context performInjectionOn:result];
        }
    }     
    return result;
}




- (void) internalContextLoaded:(OCSApplicationContext *) context {
    //NO OP
}

- (void)dealloc
{
    [_configInstance release];
    [super dealloc];
}
@end
