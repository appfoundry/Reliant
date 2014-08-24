//
//  OCSConfiguratorBase.m
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//

#import "OCSConfiguratorBase+ForSubclassEyesOnly.h"
#import "OCSDefinition.h"

@interface OCSConfiguratorBase () {
    /**
    Used during initialisation to make sure aliases and keys are all unique.
    */
    NSMutableArray *_keysAndAliasesRegistry;

    /**
    Registry of object definitions, derived from the configurator instance.
    @see OCSDefinition
    */
    NSMutableDictionary *_definitionRegistry;
}

@end

@implementation OCSConfiguratorBase

- (id)init {
    self = [super init];
    if (self) {
        _keysAndAliasesRegistry = [[NSMutableArray alloc] init];
        _definitionRegistry = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSArray *)objectKeys {
    return [_definitionRegistry allKeys];
}

- (NSArray *)objectKeysAndAliases {
    return [_keysAndAliasesRegistry copy];
}

- (OCSDefinition *)definitionForKeyOrAlias:(NSString *)keyOrAlias {
    OCSDefinition *def = _definitionRegistry[keyOrAlias];
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

/**
Register a key or alias. This method will raise an exception if the key or alias is already regsiterd. Keys and aliases should all be unique. This method is called in the definitionForKeyOrAlias: method.

@param keyOrAlias the key or alias to register
*/
- (void) _registerKeyOrAlias:(NSString *)keyOrAlias {
    if ([_keysAndAliasesRegistry containsObject:keyOrAlias]) {
        [NSException raise:@"OCSConfiguratorException" format:@"A key or alias with value %@ already exists, you should check your namings in your configurator", keyOrAlias];
    }

    [_keysAndAliasesRegistry addObject:keyOrAlias];
}

- (void) registerDefinition:(OCSDefinition *)definition {
    [self _registerKeyOrAlias:definition.key];
    [definition.aliases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self _registerKeyOrAlias:obj];
    }];

    _definitionRegistry[definition.key] = definition;
}


@end
