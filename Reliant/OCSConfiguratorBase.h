//
//  OCSConfiguratorBase.h
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//

#import "OCSConfigurator.h"

/**
 Base configurator class, meant to be extended. Provides a dictionary for holding bean definitions and an array for all keys and aliases, to make sure they are unique. Also holds an initializing flag, which will be set to false, once all initializing work is done in the contextLoaded: method.
 
 Subclasses should import OCSConfiguratorBase(ForSubclassEyesOnly)
 
 @author Mike Seghers
 @see OCSConfiguratorBase(ForSubclassEyesOnly)
*/

#import "OCSScope.h"

@protocol OCSObjectFactory;

@interface OCSConfiguratorBase : NSObject<OCSConfigurator>

@end
