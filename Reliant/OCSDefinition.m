//
//  OCSDefinition.m
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//

#import "OCSDefinition.h"

#import "OCSScope.h"

@interface OCSDefinition () {
    NSMutableArray *_aliases;
}

@end

@implementation OCSDefinition

@synthesize implementingClass, singleton, key;

- (id) init
{
    self = [super init];
    if (self) {
        _aliases = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addAlias:(NSString *)alias {
    [_aliases addObject:alias];
}

- (BOOL)isAlsoKnownWithAlias:(NSString *)alias {
    return [_aliases containsObject:alias];
}

- (void)dealloc
{
    [_aliases release];
    [super dealloc];
}

@end
