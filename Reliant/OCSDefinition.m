//
//  OCSDefinition.m
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


#import <objc/runtime.h>
#import "OCSDefinition.h"
#import "OCSScope.h"
#import "OCSSingletonScope.h"

/**
 Definition private category. Holds private ivars and methods.
 */
@interface OCSDefinition () {
    /**
     Alias regisry.
     */
    NSMutableArray *_aliases;
}

/**
 Flag to indicate if the object is a singleton or a prototype. Singletons, as the words says, will only be initialized once in a context. Prototypes will be created each time they are requested.
 */
@property (nonatomic, assign, readwrite) BOOL singleton;
@end

@implementation OCSDefinition

@synthesize implementingClass, key, singleton, lazy;

- (NSArray *) aliases {
    return [_aliases copy];
}

- (id) init
{
    self = [super init];
    if (self) {
        _aliases = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)singleton {
    return _scopeClass == [OCSSingletonScope class];
}

- (void)setScopeClass:(Class)scopeClass {
    if (!class_conformsToProtocol(scopeClass, @protocol(OCSScope))){
        [NSException raise:@"NonScopeClassError" format:@"The given class %@ does not conform to the OCSScope protocol",scopeClass];
    }
    _scopeClass = scopeClass;
}

- (void)addAlias:(NSString *)alias {
    [_aliases addObject:alias];
}

- (BOOL)isAlsoKnownWithAlias:(NSString *)alias {
    return [_aliases containsObject:alias];
}


@end
