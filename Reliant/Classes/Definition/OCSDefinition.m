//
//  OCSDefinition.m
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//



#import "OCSDefinition.h"

/**
Definition private category. Holds private ivars and methods.
*/
@interface OCSDefinition () {
    /**
    Alias regisry.
    */
    NSMutableArray *_aliases;
}

@end

@implementation OCSDefinition

- (NSArray *)aliases {
    return [_aliases copy];
}

- (id)init {
    self = [super init];
    if (self) {
        _aliases = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)singleton {
    return [self.scope isEqualToString:@"singleton"];
}

- (void)addAlias:(NSString *)alias {
    [_aliases addObject:alias];
}

- (BOOL)isAlsoKnownWithAlias:(NSString *)alias {
    return [_aliases containsObject:alias];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"OCSDefinition: %@ (%@) Aliases: %@ Scope: %@", self.key, (self.lazy ? @"lazy" : @"eager"), self.aliases, self.scope];
}


@end
