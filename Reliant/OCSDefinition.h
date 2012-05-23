//
//  OCSDefinition.h
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


@interface OCSDefinition : NSObject

/**
 The key for the definition. This key will also be the key for looking up the object.
 */
@property (nonatomic, retain) NSString *key;

/**
 The class of the object that this definition represents.
 */
@property (nonatomic, assign) Class implementingClass;

/**
 Flag to indicate if the object is a singleton or a prototype. Singletons, as the words says, will only be initialized once in a context. Prototypes will be created each time they are requested.
 */
@property (nonatomic, assign) BOOL singleton;

/**
 Adds an alias for the object. An object can be retrieved through one of these aliases.
 
 @param alias the alias
 */
- (void) addAlias:(NSString *) alias;

/**
 Returns YES if the definition holds the given alias. NO otherwise.
 
 @param alias the alias to look for
 */
- (BOOL) isAlsoKnownWithAlias:(NSString *) alias;

@end
