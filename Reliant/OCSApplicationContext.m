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
    
    for (int i = 0; i < propertyCount; i++) {
        NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        //Only support readwrite object properties, ignore all other
        NSRange objectRange = [propertyAttributes rangeOfString:@"T@"];
        NSRange readOnlyRange = [propertyAttributes rangeOfString:@",R"];
        
        if (objectRange.location != NSNotFound && readOnlyRange.location == NSNotFound && [object valueForKey:name] == nil) {
            id instance = [_configurator objectForKey:name inContext:self];
            if (instance) {
                [object setValue:instance forKey:name];
            
            
#if DEBUG
            } else {
                NSLog(@"Property %@ for object %@ could not be injected, nothing found in the configurator's registry", name, object);
#endif
            }
        
#if DEBUG
        } else {
            NSLog(@"Property %@ for object %@ was not injected, not an object or readonly", name, object);
#endif
        }
    }
    free(properties);
    
    Class superClass = class_getSuperclass(thisClass);
    if (superClass) {
        [self _recursiveInjectionOn:object forMetaClass:superClass];
    }
}



@end
