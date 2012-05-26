//
//  OCSConfiguratorBase.m
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OCSConfiguratorBase.h"
#import "OCSConfiguratorBase+ForSubclassEyesOnly.h"

#import "OCSDefinition.h"
#import "OCSApplicationContext.h"

@implementation OCSConfiguratorBase

- (BOOL) initializing {
    return _initializing;
}

- (void) setInitializing:(BOOL)initializing {
    _initializing = initializing;
}

- (id)init
{
    self = [super init];
    if (self) {
        _keysAndAliasRegistry = [[NSMutableArray alloc] init];
        _definitionRegistry = [[NSMutableDictionary alloc] init];
        _initializing = YES;
    }
    return self;
}

- (id) objectForKey:(NSString *)keyOrAlias inContext:(OCSApplicationContext *)context {
    id result = nil;
    if (!self.initializing) {
        result = [self internalObjectForKey:keyOrAlias inContext:context];
    }
    return result;
}

- (void) contextLoaded:(OCSApplicationContext *) context {
    for (NSString *key in [_definitionRegistry allKeys]) {
        OCSDefinition *definition = [_definitionRegistry objectForKey:key];
        //Load eager singletons directly
        if (definition.singleton && !definition.lazy) {
            id instance = [self internalObjectForKey:key inContext:context];
            [context performInjectionOn:instance];
        }
    }
    
    [self internalContextLoaded:context];
    
    _initializing = NO;
}

- (void)dealloc
{
    [_keysAndAliasRegistry release];
    [_definitionRegistry release];
    [super dealloc];
}

@end
