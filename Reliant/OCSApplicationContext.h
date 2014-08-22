//
//  OCSApplicationContext.h
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

@protocol OCSConfigurator;
@protocol OCSScope;
@protocol OCSObjectFactory;
@protocol OCSScopeFactory;

/**
 The application's dependency injection (DI) context. To bootstrap Reliant, you should use this class, or one of it's derivatives.
 
 Initialize an instance using the designated init method OCSApplicationContext::initWithConfigurator:
 
 Objects that are not in the DI context can still optain objects on the DI context using this class.
 
 @author Mike Seghers
 */
@interface OCSApplicationContext : NSObject

@property (nonatomic, readonly) id<OCSScopeFactory> scopeFactory;

/**
 Designated initializer. Prepares the application context with the given configurator.
 
 @param configurator The configurator that will be used to setup the context.
 */
- (instancetype) initWithConfigurator:(id<OCSConfigurator>) configurator;

- (instancetype) initWithConfigurator:(id<OCSConfigurator>) configurator scopeFactory:(id<OCSScopeFactory>) scopeFactory;

/**
 Returns the object know by the key (might be an alias to). If an object for the given key (or an alias) is not found, nil is returned.
 
 @param key the key
 */
- (id) objectForKey:(NSString *) key;

/**
Call this method if you want to inject an object with objects known in the context. Injection is always done by properties here. ALL properties in your instance will be tried. If a matching object (by name AND type) is found, it is injected.
 
 @param object the object to be injected
 */
- (void) performInjectionOn:(id) object;

/**
 Bootstrap the application context. This will load object definitions via the given configurator. Eager singletons will be loaded as well. Loads any necesarry resources, and notifies the configurator that it has been loaded.
 */
- (BOOL) start;

@end
