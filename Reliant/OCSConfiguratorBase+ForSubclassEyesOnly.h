//
//  OCSConfiguratorBase+ForSubclassEyesOnly.h
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//

#import "OCSConfiguratorBase.h"

@class OCSDefinition;

/**
 When creating subclasses of the OCSConfiguratorBase, you should import this header file in it's implementation. This header file should never be used outside a subclass implementation. It's methods should also never be called from outside a subclass.
 
 @author Mike Seghers
 */
@interface OCSConfiguratorBase (ForSubclassEyesOnly)

/**
 Call this method to register a definition you want to store in this configuration.
 
 @param definition The definition to register.
 
 @see OCSDefinition
 */
- (void) registerDefinition:(OCSDefinition *) definition;

@end
