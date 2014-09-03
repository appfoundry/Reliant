//
//  OCSReliantExcludingPropertyProvider.h
//  Reliant
//
//  Created by Michael Seghers on 27/10/13.
//
//

#import <Foundation/Foundation.h>

/**
Mark your object to conform to this protocol to make sure reliant does not try to inject properties which where not meant for injection.

This protocol is adopted by NSObject, UIResponder and UIViewController categories out of the box.
REMARK: Normally you should not need to adopt this protocol, as reliant will only try to inject properties with a name
known by the injecting context. Only if you have a property named the same as an object in this context which should be
ignored for injection, should you adopt this protocol.
*/
@protocol OCSReliantExcludingPropertyProvider <NSObject>

/**
Returns YES if the property with the given name should be ignored by reliant. Returns NO if reliant can inject the property.

@param name the name of the property which is passed in by Reliant to test if it should be ignored.
*/
+ (BOOL)ocsReliantShouldIgnorePropertyWithName:(NSString *) name;

@end
