//
//  OCSApplicationContext.m
//  Reliant
//
//  Created by Michael Seghers on 2/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
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


#import <objc/runtime.h>

#import "OCSApplicationContext.h"
#import "OCSConfigurator.h"
#import "OCSReliantExcludingPropertyProvider.h"

/**
 Application context private category. Holds private ivars and methods.
 */
@interface OCSApplicationContext () {
    /**
     The configurator instance.
     */
    id<OCSConfigurator> _configurator;
}

/**
 Recursive method for injecting objects with their dependencies. This method recurse over parent classes, so all properties on parrent classes are injected as well.
 
 @param object the object to inject
 @param metaClass the metaClass for the current iteration. 
 */
- (void) _recursiveInjectionOn:(id) object forMetaClass:(Class) metaClass;

@end

@implementation OCSApplicationContext


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id) initWithConfigurator:(id<OCSConfigurator>)configurator {
    self = [self init];
    if (self) {
        _configurator = configurator;
    }
    return self;
}

- (id) objectForKey:(NSString *)key {
    return [_configurator objectForKey:key inContext:self];
}

- (BOOL) start {
    //Done registering all objects, now do injections for singletons using KVC
    [_configurator contextLoaded:self];
    
    return YES;
}

- (void)performInjectionOn:(id)object {
    [self _recursiveInjectionOn:object forMetaClass:[object class]];
}

- (void) _recursiveInjectionOn:(id) object forMetaClass:(Class) thisClass {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(thisClass, &propertyCount);
    id classAsID = thisClass;
    
    NSArray *ignoredProperties;
    if ([classAsID isKindOfClass:[NSObject class]] && [classAsID respondsToSelector:@selector(OCS_propertiesReliantShouldIgnore)]) {
        ignoredProperties = [classAsID OCS_propertiesReliantShouldIgnore];
    } else {
        ignoredProperties = @[];
    }
    

    for (int i = 0; i < propertyCount; i++) {
        NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSArray *components = [propertyAttributes componentsSeparatedByString:@","];
        BOOL readOnly = [components containsObject:@"R"];
        NSString *objectType = [[components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self MATCHES %@", @"T.*"]] lastObject];
        BOOL isObject = [objectType characterAtIndex:1] == '@';
        BOOL isIgnoredProperty = [ignoredProperties containsObject:name];
        NSString *customGetter = [[[components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self MATCHES %@", @"G.*"]] lastObject] substringFromIndex:1];
        NSString *customSetter = [[[components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self MATCHES %@", @"S.*"]] lastObject] substringFromIndex:1];

        

        if (isObject && !readOnly && !isIgnoredProperty) {
            id currentValue = nil;
            if (customGetter) {
                SEL customGetterSelector = NSSelectorFromString(customGetter);
                if ([object respondsToSelector:customGetterSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    currentValue = [object performSelector:customGetterSelector];
#pragma clang diagnostic pop
                }
            } else {
                SEL standardGetterSelector = NSSelectorFromString(name);
                if ([object respondsToSelector:standardGetterSelector]) {
                    currentValue = [object valueForKey:name];
                }
            }
            
            
            if (!currentValue) {
                id instance = [_configurator objectForKey:name inContext:self];
                if (instance) {
                    if (customSetter) {
                        SEL customSetterSelector = NSSelectorFromString(customSetter);
                        if ([object respondsToSelector:customSetterSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                            [object performSelector:customSetterSelector withObject:instance];
#pragma clang diagnostic pop
                        } else {
                            DLog(@"Property %@ for object %@ could not be injected, the setter %@ is not implemented", name, object, customSetter);
                        }
                    } else {
                        NSString *allButFirst = [name substringFromIndex:1];
                        NSString *first = [[name substringToIndex:1] uppercaseString];
                        
                        SEL standardSetterSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", first, allButFirst]);
                        if ([object respondsToSelector:standardSetterSelector]) {
                            [object setValue:instance forKey:name];
                        } else {
                            DLog(@"Property %@ for object %@ could not be injected, the setter %@ is not implemented", name, object, customSetter);
                        }
                    }
                } else {
                    DLog(@"Property %@ for object %@ could not be injected, nothing found in the configurator's registry", name, object);
                }
            } else {
               DLog(@"Property %@ for object %@ was not injected, the property has already been set", name, object);
            }
        } else {
            DLog(@"Property %@ for object %@ was not injected, it is not an object, it is readonly and/or it is excluded", name, object);
        }
    }
    free(properties);
    
    Class superClass = class_getSuperclass(thisClass);
    if (superClass) {
        [self _recursiveInjectionOn:object forMetaClass:superClass];
    }
}



@end
