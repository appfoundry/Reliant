//
//  OCSConfiguratorConstants.h
//  Reliant
//
//  Created by Michael Seghers on 21/05/12.
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

#ifndef Reliant_OCSConfiguratorConstants_h

/**
 The prefix used in OCSConfiguratorFromClass to detect a method which will create a lazy singleton.
 */
#define LAZY_SINGLETON_PREFIX @"createSingleton"

/**
 The prefix used in OCSConfiguratorFromClass to detect a method which will create an eager singleton.
 */
#define EAGER_SINGLETON_PREFIX @"createEagerSingleton"


/**
 The prefix used in OCSConfiguratorFromClass to detect a method which will create a prototype.
 */
#define PROTOTYPE_PREFIX @"createPrototype"

/**
 The prefix used in OCSConfiguratorFromClass to call optional alias methods for a certain object.
 */
#define ALIAS_METHOD_PREFIX @"aliasesFor"

#define Reliant_OCSConfiguratorConstants_h
#endif
