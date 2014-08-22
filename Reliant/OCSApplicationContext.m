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
#import "OCSDLogger.h"
#import "OCSPropertyRuntimeInfo.h"
#import "OCSConfiguratorFromClass.h"
#import "OCSObjectFactory.h"
#import "OCSDefinition.h"
#import "OCSScopeFactory.h"
#import "OCSDefaultScopeFactory.h"

/**
Application context private category. Holds private ivars and methods.
*/
@interface OCSApplicationContext () {
    /**
    The configurator instance.
    */
    id<OCSConfigurator> _configurator;
    id<OCSScopeFactory> _scopeFactory;
}

/**
Recursive method for injecting objects with their dependencies. This method iterates over parent classes, so all properties on parent classes are injected as well.

@param object the object to inject
@param metaClass the metaClass for the current iteration.
*/
- (void)_recursiveInjectionOn:(id)object forMetaClass:(Class)metaClass;

@end

@implementation OCSApplicationContext

- (id)init {
    OCSConfiguratorFromClass *autoConfig = [[OCSConfiguratorFromClass alloc] init];
    return [self initWithConfigurator:autoConfig];
}

- (id)initWithConfigurator:(id <OCSConfigurator>)configurator {
    OCSDefaultScopeFactory *defaultScopeFactory = [[OCSDefaultScopeFactory alloc] init];
    return [self initWithConfigurator:configurator scopeFactory:defaultScopeFactory];
}

- (instancetype)initWithConfigurator:(id <OCSConfigurator>)configurator scopeFactory:(id <OCSScopeFactory>)scopeFactory {
    self = [super init];
    if (self && configurator && scopeFactory) {
        _configurator = configurator;
        _scopeFactory = scopeFactory;
    } else {
        self = nil;
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    id result = nil;
    OCSDefinition *definition = [_configurator definitionForKeyOrAlias:key];
    if (definition) {
        id <OCSScope> scope = [_scopeFactory scopeForName:definition.scope];
        if (scope) {
            result = [scope objectForKey:definition.key];
            if (!result) {
                result = [_configurator.objectFactory createObjectForDefinition:
                        definition                                    inContext:self];
                [self performInjectionOn:result];
                [scope registerObject:result forKey:definition.key];
            }
        }
    }
    return result;
}

- (BOOL)start {
    [self _initAndInjectNonLazyObjects];

    return YES;
}

- (void)_initAndInjectNonLazyObjects {
    for (NSString *key in [_configurator objectKeys]) {
        OCSDefinition *definition = [_configurator definitionForKeyOrAlias:key];
        if (definition.singleton && !definition.lazy) {
            [self objectForKey:key];
        }
    }
}

- (void)performInjectionOn:(id)object {
    [self _recursiveInjectionOn:object forMetaClass:[object class]];
}

- (void)_recursiveInjectionOn:(id)object forMetaClass:(Class)thisClass {
    [self _injectObject:object forClass:thisClass];
    Class superClass = class_getSuperclass(thisClass);
    if (superClass) {
        [self _recursiveInjectionOn:object forMetaClass:superClass];
    }
}

- (void)_injectObject:(id)object forClass:(Class)thisClass {
    id classAsID = thisClass;
    BOOL checkIgnoredProperties = ([classAsID isKindOfClass:[NSObject class]] && [classAsID respondsToSelector:@selector(OCS_reliantShouldIgnorePropertyWithName:)]);
    [_configurator.objectKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        objc_property_t foundProperty = class_getProperty(thisClass, [key cStringUsingEncoding:NSUTF8StringEncoding]);
        if (foundProperty) {
            OCSPropertyRuntimeInfo *pi = [[OCSPropertyRuntimeInfo alloc] initWithProperty:foundProperty];
            BOOL isIgnoredProperty = checkIgnoredProperties && [classAsID OCS_reliantShouldIgnorePropertyWithName:pi.name];
            if (pi.isObject && !pi.readOnly && !isIgnoredProperty) {
                [self _checkCurrentPropertyValueOnObject:object withProperty:pi];
            } else {
                DLog(@"Property %@ for object %@ was not injected, it is not an object, it is readonly and/or it is excluded", [pi name], object);
            }
        }
    }];
}

- (void)_checkCurrentPropertyValueOnObject:(id)object withProperty:(OCSPropertyRuntimeInfo *)pi {
    id currentValue = [self _currentValueFromObject:object property:pi];
    if (!currentValue) {
        [self _injectPropertyOnObject:object withProperty:pi];
    } else {
        DLog(@"Property %@ for object %@ was not injected, the property has already been set", [pi name], object);
    }
}

- (void)_injectPropertyOnObject:(id)object withProperty:(OCSPropertyRuntimeInfo *)pi {
    id value = [self objectForKey:pi.name];
    if (value) {
        [self _setPropertyValue:value onObject:object property:pi];
    } else {
        DLog(@"Property %@ for object %@ could not be injected, nothing found in the configurator's registry", [pi name], object);
    }
}

- (void)_setPropertyValue:(id)value onObject:(id)object property:(OCSPropertyRuntimeInfo *)pi {
    if (pi.customSetter) {
        [self _setPropertyValue:value onObject:object withCustomSetter:pi.customSetter];
    } else {
        [self _setPropertyValue:value onObject:object withDefaultSetter:pi.name];
    }
}

- (void)_setPropertyValue:(id)value onObject:(id)object withDefaultSetter:(NSString *)name {
    NSString *allButFirst = [name substringFromIndex:1];
    NSString *first = [[name substringToIndex:1] uppercaseString];

    NSString *setterName = [NSString stringWithFormat:@"set%@%@:", first, allButFirst];
    SEL standardSetterSelector = NSSelectorFromString([NSString stringWithFormat:setterName, first, allButFirst]);
    if ([object respondsToSelector:standardSetterSelector]) {
        [object setValue:value forKey:name];
    } else {
        DLog(@"Property %@ for object %@ could not be injected, the setter %@ is not implemented", name, object, setterName);
    }
}

- (void)_setPropertyValue:(id)value onObject:(id)object withCustomSetter:(NSString *)customSetter {
    SEL customSetterSelector = NSSelectorFromString(customSetter);
    if ([object respondsToSelector:customSetterSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [object performSelector:customSetterSelector withObject:value];
#pragma clang diagnostic pop
    } else {
        DLog(@"The setter %@ is not implemented", customSetter);
    }
}

- (id)_currentValueFromObject:(id)object property:(OCSPropertyRuntimeInfo *)pi {
    id currentValue = nil;
    if (pi.customGetter) {
        currentValue = [self _currentValueThroughCustomGetter:pi.customGetter fromObject:object];
    } else {
        currentValue = [self _currentValueThroughDefaultGetter:pi.name fromObject:object];
    }
    return currentValue;
}

- (id)_currentValueThroughDefaultGetter:(NSString *)name fromObject:(id)object {
    id currentValue = nil;
    SEL standardGetterSelector = NSSelectorFromString(name);
    if ([object respondsToSelector:standardGetterSelector]) {
        currentValue = [object valueForKey:name];
    }
    return currentValue;
}

- (id)_currentValueThroughCustomGetter:(NSString *)customGetterName fromObject:(id)object {
    id currentValue;
    SEL customGetterSelector = NSSelectorFromString(customGetterName);
    if ([object respondsToSelector:customGetterSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        currentValue = [object performSelector:customGetterSelector];
#pragma clang diagnostic pop
    }
    return currentValue;
}

@end
