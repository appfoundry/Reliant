//
//  OCSDefinition.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
Describes an object configuration in the application context.
*/
@interface OCSDefinition : NSObject

/**
The key for the definition. This key will also be the key for looking up the object.
*/
@property (nonatomic, strong) NSString *key;

/**
The aliases for the definition. These aliases also identify this definition.
 */
@property (nonatomic, readonly) NSArray *aliases;

/**
The class of the object that this definition represents.
 */
@property (weak, nonatomic) Class implementingClass;

/**
Flag to indicate when the object should be loaded in the application context. Lazy means only when first requested, eager means directly at startup. This only makes sence for singleton objects. Prototypes are always lazily loaded.
 */
@property (nonatomic, assign) BOOL lazy;

/**
Flag to indicate if the object is a singleton or a prototype. Singletons, as the words says, will only be initialized once in a context. Prototypes will be created each time they are requested.
*/
@property (nonatomic, assign) BOOL singleton;

/**
The scope name for this definition. The name should be mapped to a scope instance, using an OCSScopeFactory implementation.

@see OCSScope
@see OCSScopeFactory
*/
@property(nonatomic, strong) NSString *scope;

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
