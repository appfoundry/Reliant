//
//  OCSConfiguratorBase.h
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//

#import "OCSConfigurator.h"

#import "OCSScope.h"

@protocol OCSObjectFactory;

/**
Base configurator class, meant to be extended. Provides a dictionary for holding bean definitions and an array for all keys and aliases, to make sure they are unique.

You should never initialize this class by itself, it's sole purpose is to be extended!

Subclasses should import OCSConfiguratorBase(ForSubclassEyesOnly)
@see OCSConfiguratorBase(ForSubclassEyesOnly)
*/
@interface OCSConfiguratorBase : NSObject<OCSConfigurator>

@end
