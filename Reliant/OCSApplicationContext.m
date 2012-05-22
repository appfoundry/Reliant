//
//  OCSApplicationContext.m
//  Reliant
//
//  Created by Michael Seghers on 2/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//

#import "OCSApplicationContext.h"
#import <objc/runtime.h>

#import "OCSConfiguratorFromClass.h"
#import "OCSDefinition.h"
#import "OCSConfigurator.h"

@interface OCSApplicationContext () {
    id<OCSConfigurator> _configurator;
}

- (void) _recursiveInjectionOn:(id) object forHierarchicalClass:(Class) thisClass ;

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
        _configurator = [configurator retain];
    }
    return self;
}



/**
 * Returns the object know by the key (might be an alias to). If an object for the given key (or an alias) is not found, nil is returned.
 */
- (id) objectForKey:(NSString *)key {
    return [_configurator objectForKey:key inContext:self];
}

/**
 * Start the application context, loading any necesarry resources, and notifiying the configurator that it has been loaded.
 *
 * @return true if startup is succesful, false otherwise
 */
- (BOOL) start {
    //Done registering all objects, now do injections for singletons using KVC
    //Option 1: Put macro in classes, wich adds a method to the impl (can be private), this method will then be called, but what is it's signature, and how to mark WHAT needs to be injected
    //Option 2: do it here with injection macro's (see spring configurator with anotations
    //...
    NSLog(@"Starting application context...");
    [_configurator contextLoaded:self];
    NSLog(@"Application context started...");
    
    
    return YES;
}

/**
 * Inject all known dependencies in the given object.
 */
- (void)performInjectionOn:(id)object {
    [self _recursiveInjectionOn:object forHierarchicalClass:[object class]];
}

- (void) _recursiveInjectionOn:(id) object forHierarchicalClass:(Class) thisClass {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(thisClass, &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        //Only support readwrite object properties, ignore all other
        NSRange objectRange = [propertyAttributes rangeOfString:@"T@"];
        NSRange readOnlyRange = [propertyAttributes rangeOfString:@",R"];
        
        if (objectRange.location != NSNotFound && readOnlyRange.location == NSNotFound) {
            id instance = [_configurator objectForKey:name inContext:self];
            if (instance) {
                [object setValue:instance forKey:name];
            } else {
                NSLog(@"Property %@ for object %@ could not be injected, nothing found in the configurator's    registry", name, object);
            }
        } else {
            NSLog(@"Property %@ for object %@ was not injected, not an object or readonly", name, object);
        }
    }
    free(properties);
    
    Class superClass = class_getSuperclass(thisClass);
    if (superClass) {
        [self _recursiveInjectionOn:object forHierarchicalClass:superClass];
    }
}

- (void)dealloc
{
    [_configurator release];
    [super dealloc];
}


@end
