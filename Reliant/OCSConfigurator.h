//
//  OCSConfigurator.h
//  Reliant
//
//  Created by Michael Seghers on 7/05/12.
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

@class OCSApplicationContext;
@protocol OCSObjectFactory;
@class OCSDefinition;

/**
 Describes the possibilities of a configurator. 
 
 A configurator is responsible for setting up definitions and creating object instances.
 
 You should never try to retrieve objects while the configurator is still initializing itself.
 @see OCSDefinition
 
 @author Mike Seghers
 */
@protocol OCSConfigurator <NSObject>

/**
 A configurator decides which object factory the application context will use to create objects based on the definitions found in this configurator.
*/
@property (readonly, nonatomic) id<OCSObjectFactory> objectFactory;

/**
 All keys of the definitions found in this configurator. This list includes both keys and aliases.
*/
@property (readonly, nonatomic, copy) NSArray *objectKeys;

/**
Get a definition for the given key or alias.

@param keyOrAlias the key or alias of the definition you are looking for

@return the definition with the given key or alias, or nil if no such definition exists.
*/
- (OCSDefinition *) definitionForKeyOrAlias:(NSString *) keyOrAlias;


@end
