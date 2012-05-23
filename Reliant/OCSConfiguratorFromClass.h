//
//  OCSConfiguratorFromClass.h
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


#import <Foundation/Foundation.h>

#import "OCSConfigurator.h"

/**
 Configurator implementation which derives definitions from methods in a given class instance. The class instance is also used to create object instances.
 
 TODO Write on how to make a configurator class
 */
@interface OCSConfiguratorFromClass : NSObject<OCSConfigurator>

/**
 Designated initializer.
 
 @param configuratorClass the class which holds methods, able to create objects.
 @return self
 */
- (id)initWithClass:(Class) configuratorClass;

@end
