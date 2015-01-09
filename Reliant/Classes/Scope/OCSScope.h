//
//  OCSScope.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
Describes a scope. A scope represent a context in which objects are contained.
 */
@protocol OCSScope <NSObject>

/**
Get an object in the given scope with the given key.
 
@param key the key
@return the object for the given key. Return nil if the object was not found.
 */
- (id) objectForKey:(NSString *) key;

/**
Register an object in this scope with the given key.
 
@param object the object to register
@param key the key
 */
- (void) registerObject:(id) object forKey:(NSString *) key;

/**
Get all known keys in this scope.
*/
- (NSArray *)allKeys;

@end
