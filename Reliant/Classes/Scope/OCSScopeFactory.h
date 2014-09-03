//
//  OCSScopeFactory.h
//  Reliant
//
//  Created by Michael Seghers on 22/08/14.
//
//

#import <Foundation/Foundation.h>

@protocol OCSScope;

/**
A scope factory is able to return scopes known by name.
*/
@protocol OCSScopeFactory <NSObject>

/**
Return the scope known by the given name, or a default scope if no such scope exists.
It is up to the implementation to choose this default scope.

@param name the name to be used for searching a scope.
*/
- (id<OCSScope>)scopeForName:(NSString *) name;

@end
