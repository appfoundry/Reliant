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

/**
 Describes the possibilities of a configurator. 
 
 A configurator is responsible for setting up definitions and creating object instances.
 
 You should never try to retrieve objects while the configurator is still initializing itself.
 @see OCSDefinition
 
 @author Mike Seghers
 */
@protocol OCSConfigurator <NSObject>

/**
 Flag indicating wether this configurator is still initializing.
 
 While initializing, you should not try to retrieve any objects from the configurator, as it will always return nil in this situation.
 @return YES if still initializing, no otherwise.
 */
@property (readonly, nonatomic, assign) BOOL initializing;

/**

*/
@property (readonly, nonatomic, copy) NSArray *objectKeys;

/**
 Notifies the configurator that the context is fully loaded and ready to be configured. You should never call this method yourself!
 
 Implementations must set the initializing flag to YES at the end of this method.
 
 TODO Consider this to be hidden in the implementation!
 
 @param context the context which was loaded
 */
- (void) contextLoaded:(OCSApplicationContext *) context;

/**
 Returns the object for the given key or alias for the given context. While the configurator is initializing, this method will return nil. Also, when an object for the given key or alias can not be found, nil is returned. Callers can distinguish nil significatne with the initializing flag.
 
 @param keyOrAlias The key or alias to look for.
 @param context The context in which this object is asked.
 
 @return the object, or nil if we are still initializing or if the object for the given key or alias is not found.
 */
- (id) objectForKey:(NSString *) keyOrAlias inContext:(OCSApplicationContext *) context;

@end
