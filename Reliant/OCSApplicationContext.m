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
#import "OCSClassRuntimeInfo.h"
#import "OCSPropertyRuntimeInfo.h"

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
- (void)_recursiveInjectionOn:(id)object forMetaClass:(Class)metaClass;

@end

@implementation OCSApplicationContext


- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)initWithConfigurator:(id<OCSConfigurator>)configurator {
    self = [self init];
    if (self) {
        _configurator = configurator;
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    return [_configurator objectForKey:key inContext:self];
}

- (BOOL)start {
    //Done registering all objects, now do injections for singletons using KVC
    [_configurator contextLoaded:self];

    return YES;
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
    OCSClassRuntimeInfo *classInfo = [[OCSClassRuntimeInfo alloc] initWithClass:thisClass];
    [classInfo enumeratePropertiesWithBlock:^(OCSPropertyRuntimeInfo *pi) {
        BOOL isIgnoredProperty = checkIgnoredProperties && [classAsID OCS_reliantShouldIgnorePropertyWithName:pi.name];
        if (pi.isObject && !pi.readOnly && !isIgnoredProperty) {
            [self _chekCurrentPropertyValueOnObject:object withProperty:pi];
        } else {
            DLog(@"Property %@ for object %@ was not injected, it is not an object, it is readonly and/or it is excluded", name, object);
        }
    }];
}

- (void)_chekCurrentPropertyValueOnObject:(id)object withProperty:(OCSPropertyRuntimeInfo *) pi {
    id currentValue = [self _currentValueFromObject:object property:pi];
    if (!currentValue) {
        [self _injectPropertyOnObject:object withProperty:pi];
    } else {
        DLog(@"Property %@ for object %@ was not injected, the property has already been set", name, object);
    }
}

- (void)_injectPropertyOnObject:(id)object withProperty:(OCSPropertyRuntimeInfo *) pi {
    id value = [_configurator objectForKey:pi.name inContext:self];
    if (value) {
        [self _setPropertyValue:value onObject:object property:pi];
    } else {
        DLog(@"Property %@ for object %@ could not be injected, nothing found in the configurator's registry", name, object);
    }
}

- (void)_setPropertyValue:(id)value onObject:(id)object property:(OCSPropertyRuntimeInfo *) pi {
    if (pi.customSetter) {
        [self _setPropertyValue:value onObject:object withCustomSetter:pi.customSetter];
    } else {
        [self _setPropertyValue:value onObject:object withDefaultSetter:pi.name];
    }
}


- (void)_setPropertyValue:(id)value onObject:(id)object withDefaultSetter:(NSString *)name {
    NSString *allButFirst = [name substringFromIndex:1];
    NSString *first = [[name substringToIndex:1] uppercaseString];

    SEL standardSetterSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", first, allButFirst]);
    if ([object respondsToSelector:standardSetterSelector]) {
        [object setValue:value forKey:name];
    } else {
        DLog(@"Property %@ for object %@ could not be injected, the setter %@ is not implemented", name, object, customSetter);
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
        DLog(@"Property %@ for object %@ could not be injected, the setter %@ is not implemented", name, object, customSetter);
    }
}

- (id)_currentValueFromObject:(id)object property:(OCSPropertyRuntimeInfo *) pi {
    id currentValue = nil;
    if (pi.customGetter) {
        currentValue = [self _currentValueThroughCustomGetter:pi.customGetter fromObject:object];
    } else {
        currentValue = [self _currentValueThroughDefaultGetter:pi.name fromObject:object];
    }
    return currentValue;
}

- (id)_currentValueThroughDefaultGetter:(NSString *)name fromObject:(id)object {
    id currentValue;
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
