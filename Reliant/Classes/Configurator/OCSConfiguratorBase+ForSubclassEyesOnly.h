//
//  OCSConfiguratorBase+ForSubclassEyesOnly.h
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//

#import "OCSConfiguratorBase.h"

@class OCSDefinition;

/**
When creating subclasses of the OCSConfiguratorBase, you should import this header file in it's implementation.
This header file should never be used outside a subclass implementation. It's methods should also never be called
from outside a subclass.
*/
@interface OCSConfiguratorBase (ForSubclassEyesOnly)

/**
Stores an object definition in this configurator.

@param definition The definition to register.

@see OCSDefinition
*/
- (void) registerDefinition:(OCSDefinition *) definition;

@end
