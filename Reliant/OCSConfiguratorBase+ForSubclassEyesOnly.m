//
//  OCSConfiguratorBase+ForSubclassEyesOnly.m
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//

#import "OCSConfiguratorBase+ForSubclassEyesOnly.h"

#import "OCSDefinition.h"

@implementation OCSConfiguratorBase (ForSubclassEyesOnly)

@dynamic initializing;

/**
 Register a key or alias. This method will raise an exception if the key or alias is already regsiterd. Keys and aliases should all be unique. This method is called in the definitionForKeyOrAlias: method.
 
 @param keyOrAlias the key or alias to register
 */
- (void) _registerKeyOrAlias:(NSString *)keyOrAlias {
    if ([_keysAndAliasRegistry containsObject:keyOrAlias]) {
        [NSException raise:@"OCSConfiguratorException" format:@"A key or alias with value %@ already exists, you should check your namings in your configurator", keyOrAlias];
        return;
    }
    
    [_keysAndAliasRegistry addObject:keyOrAlias];
}

- (OCSDefinition *) definitionForKeyOrAlias:(NSString *)keyOrAlias {
    OCSDefinition *def = [_definitionRegistry objectForKey:keyOrAlias];
    if (!def) {
        for (OCSDefinition *definition in [_definitionRegistry allValues]) {
            if ([definition.key isEqualToString:keyOrAlias] || [definition isAlsoKnownWithAlias:keyOrAlias]) {
                def = definition;
                break;
            }
        }
    }
    
    return def;
}

- (void) registerDefinition:(OCSDefinition *)definition {
    [self _registerKeyOrAlias:definition.key];
    [definition.aliases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self _registerKeyOrAlias:obj];
    }];
    
    [_definitionRegistry setObject:definition forKey:definition.key];
}

- (void) setInitializing:(BOOL)initializing {
    if (initializing != _initializing) {
        _initializing = initializing;
    }
}

- (id) createObjectInstanceForKey:(NSString *)keyOrAlias inContext:(OCSApplicationContext *)context {
    [NSException raise:@"OCSConfiguratorException" format:@"You should implement createObjectInstanceForKey:inContext: on subclasses of OCSBaseConfigurator"];
    return nil;
}

- (void) internalContextLoaded:(OCSApplicationContext *) context {
    [NSException raise:@"OCSConfiguratorException" format:@"You should implement internalContextLoaded: on subclasses of OCSBaseConfigurator"];
}

- (id<OCSScope>)singletonScope {
    return _singletonScope;
}

@end
