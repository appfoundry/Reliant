//
//  OCSConfiguratorFromClass.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
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


#import "OCSConfiguratorBase.h"

/**
 Configurator implementation which derives definitions from methods in a given class instance. The class instance is also used to create object instances.
 
 TODO Write on how to make a configurator class
 
 @author Mike Seghers
 */
@interface OCSConfiguratorFromClass : OCSConfiguratorBase

/**
 Designated initializer. Creates OCSDefinition instances depending on methods found in the factoryClass.
 
 The factory class methods returning an id, without arguments and starting with createSingleton, createEagerSingleton and createPrototype are evaluated. The remainder of the method name is taken as the definition's key.
 
 @param factoryClass the factory class. This class holds methods for creating singletons and prototypes as well as methods to define aliases for these singletons and prototypes.
 @return self
 */
- (id)initWithClass:(Class) factoryClass;

@end
