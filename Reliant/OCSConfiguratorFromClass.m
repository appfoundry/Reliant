//
//  OCSConfiguratorFromClass.m
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//


#import "OCSConfiguratorFromClass.h"

#import <objc/runtime.h>

#import "OCSConfiguratorConstants.h"
#import "OCSConfiguratorClassProxy.h"
#import "OCSApplicationContext.h"
#import "OCSDefinition.h"
#import "OCSSingletonScope.h"
#import "OCSSwizzler.h"

@interface OCSConfiguratorFromClass () {
    id _configInstance;
    NSMutableDictionary *_definitionRegistry;
    
    BOOL _initializing;

}

- (void) _registerDefinition:(OCSDefinition *)definition forKey:(NSString *)key;
- (OCSDefinition *) _definitionForKeyOrAlias:(NSString *) keyOrAlias;
- (id) _createObjectInstanceForKey:(NSString *) key;
- (id) _objectForKey:(NSString *)key inContext:(OCSApplicationContext *)context;


@end

@implementation OCSConfiguratorFromClass

@synthesize initializing = _initializing;

- (id)initWithClass:(Class) configuratorClass
{
    self = [super init];
    if (self) {
        _initializing = YES;
        
        
        
        _configInstance = createExtendedConfiguratorInstance(configuratorClass, ^(NSString *name) {
            BOOL result = NO;
            if ([name hasPrefix:SINGLETON_PREFIX]) {
                result = YES;
            }

            return result;
        });
        _definitionRegistry = [[NSMutableDictionary alloc] init];

        unsigned int count;
        Method * methods = class_copyMethodList(configuratorClass, &count);
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
                    if ([objcStringName hasPrefix:SINGLETON_PREFIX]) {
                        def.singleton = YES;
                        offset = SINGLETON_PREFIX.length;
                    } else if ([objcStringName hasPrefix:NEW_INSTANCE_PREFIX]) {
                        def.singleton = NO;
                        offset = NEW_INSTANCE_PREFIX.length;
                    }
                    
                    if (offset) {
                        NSLog(@"Registering definition %@", def);
                        NSString *key = [objcStringName substringFromIndex:offset];
                        def.key = key;
                        //Alias where all letters are upper cased
                        [def addAlias:[key uppercaseString]];
                        //Alias where first letter is lower case
                        [def addAlias:[key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[key substringWithRange:NSMakeRange(0, 1)] lowercaseString]]];
                        
                        [self _registerDefinition:def forKey:key];
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

- (void) _registerDefinition:(OCSDefinition *)definition forKey:(NSString *)key {
    if ([_definitionRegistry objectForKey:key] != nil) {
        NSLog(@"Overriding object with name %@ to new instance %@", key, definition);
    }
    [_definitionRegistry setObject:definition forKey:key];
}

- (id) _createObjectInstanceForKey:(NSString *) key {
    OCSDefinition *definition = [_definitionRegistry objectForKey:key];
    id result = nil;
    if (definition) {
        NSString *methodPrefix = definition.singleton ? SINGLETON_PREFIX : NEW_INSTANCE_PREFIX;
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", methodPrefix, key]);
        if ([_configInstance respondsToSelector:selector]) {
            result = [_configInstance performSelector:selector];
        }
    }
    
    return result;
}

- (id) objectForKey:(NSString *)keyOrAlias inContext:(OCSApplicationContext *)context {
    id result = nil;
    if (!_initializing) {
        result = [self _objectForKey:keyOrAlias inContext:context];
    }
    return result;
}

- (id) _objectForKey:(NSString *)keyOrAlias inContext:(OCSApplicationContext *)context {
    OCSDefinition *definition = [self _definitionForKeyOrAlias:keyOrAlias];
    id result = nil;
    if (definition) {
        if (definition.singleton) {
            result = [[OCSSingletonScope sharedOCSSingletonScope] objectForKey:definition.key];
            if (result == nil) {
                result = [self _createObjectInstanceForKey:definition.key];
                
                [[OCSSingletonScope sharedOCSSingletonScope] registerObject:result forKey:definition.key];
            }
        } else {
            result = [self _createObjectInstanceForKey:definition.key];
            
            [context performInjectionOn:result];
        }
    }     
    return result;
}


- (OCSDefinition *) _definitionForKeyOrAlias:(NSString *) keyOrAlias {
    OCSDefinition *def = [_definitionRegistry objectForKey:keyOrAlias];
    if (!def) {
        for (OCSDefinition *definition in [_definitionRegistry allValues]) {
            if ([definition.key isEqualToString:keyOrAlias] || [definition isAlsoKnownWithAlias:keyOrAlias]) {
                def = definition;
                break;
            }
        }
    }
    
    return def;
}

- (id) initSwizzled {
    //Self refers to the swizzled class instance!
    self = [self initSwizzled];
    if (self) {
        id proxy = [[OCSConfiguratorClassProxy alloc] initWithConfiguratorInstance:self];
        self = proxy;
    }
    return self;
}


- (void) contextLoaded:(OCSApplicationContext *) context {
    for (NSString *key in [_definitionRegistry allKeys]) {
        OCSDefinition *definition = [_definitionRegistry objectForKey:key];
        if (definition.singleton) {
            id instance = [self _objectForKey:key inContext:context];
            [context performInjectionOn:instance];
        }
    }
    _initializing = NO;
}

- (void)dealloc
{
    [_configInstance release];
    [_definitionRegistry release];
    [super dealloc];
}
@end
