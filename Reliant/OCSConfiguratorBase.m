//
//  OCSConfiguratorBase.m
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//

#import "OCSConfiguratorBase.h"
#import "OCSConfiguratorBase+ForSubclassEyesOnly.h"

#import "OCSDefinition.h"
#import "OCSApplicationContext.h"

#import "OCSSingletonScope.h"
#import "OCSApplicationContext+Protected.h"

@implementation OCSConfiguratorBase

- (BOOL) initializing {
    return _initializing;
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

- (NSArray *)objectKeys {
    return [_keysAndAliasRegistry copy];
}

- (id) _internalObjectForKey:(NSString *) keyOrAlias inContext:(OCSApplicationContext *) context {
    OCSDefinition *definition = [self definitionForKeyOrAlias:keyOrAlias];
    id result = nil;
    if (definition) {
        //If singleton, check if we already have it in our registry. If not load it and put it there.
        //DO NOT do anything different for lazy or eager singletons. If demanded, we must always load!
        id <OCSScope> scope = [context scopeForClass:definition.scopeClass];

        if (definition.singleton) {
            result = [scope objectForKey:definition.key];
            if (result == nil) {
                result = [self createObjectInstanceForKey:definition.key inContext:context];
                [scope registerObject:result forKey:definition.key];
                
                //If we are still initializing, postpone the injection process
                //Ohterwise we can do injection.
                if (!self.initializing) {
                    [context performInjectionOn:result];
                }
            }
        } else {
            //Prototype, always create a new one
            result = [self createObjectInstanceForKey:definition.key inContext:context];
            
            [context performInjectionOn:result];
        }
    }
    return result;
}

- (id) objectForKey:(NSString *)keyOrAlias inContext:(OCSApplicationContext *)context {
    id result = nil;
    if (!self.initializing) {
        result = [self _internalObjectForKey:keyOrAlias inContext:context];
    }
    return result;
}

- (void) contextLoaded:(OCSApplicationContext *) context {
    for (NSString *key in [_definitionRegistry allKeys]) {
        OCSDefinition *definition = [_definitionRegistry objectForKey:key];
        //Load eager singletons directly
        if (definition.singleton && !definition.lazy) {
            id instance = [self _internalObjectForKey:key inContext:context];
            _initializing = NO;
            [context performInjectionOn:instance];
            _initializing = YES;
        }
    }
    
    [self internalContextLoaded:context];
    
    _initializing = NO;
}


@end
