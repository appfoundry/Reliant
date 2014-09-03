//
// Created by Michael Seghers on 22/08/14.
//

@class OCSDefinition;
@class OCSObjectContext;

/**
An object factory creates objects for an OCSObjectContext when that context decides it needs a new object for a
given definition.

@see OCSObjectContext
*/
@protocol OCSObjectFactory <NSObject>

/**
The factory creates an object, based on the given definition.

@param definition the definition which is used to create an object.
*/
- (id)createObjectForDefinition:(OCSDefinition *)definition;

/**
Binds the factory to the given context.

This method is meant to be called from within an OCSObjectContext. You should never need to call this method yourself.

@param context the context to bind this factory to
*/
- (void)bindToContext:(OCSObjectContext *)context;

@end