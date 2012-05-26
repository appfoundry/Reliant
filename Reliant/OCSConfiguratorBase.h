//
//  OCSConfiguratorBase.h
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OCSConfigurator.h"

/**
 Base configurator class, meant to be extended. Provides a dictionary for holding bean definitions. Also holds an initializing flag, which will be set to false, once all initializing work is done in the contextLoaded: method.
 
 @author Mike Seghers
*/

#import "OCSScope.h"

@interface OCSConfiguratorBase : NSObject<OCSConfigurator> {
    @private
    
    /**
     Used during initialisation to make sure aliases and keys are all unique.
     */
    NSMutableArray *_keysAndAliasRegistry;
    
    /**
     Registry of object definitions, derived from the configurator instance.
     @see OCSDefinition
     */
    NSMutableDictionary *_definitionRegistry;
    
    /**
     Flag to check if we are still initializing. While initialization is going on, we should not return any objects yet as there state might be unpredictable.
     */
    BOOL _initializing;
    
    /**
     A scope holding singletons
     */
    id<OCSScope> _singletonScope;
}

@end
