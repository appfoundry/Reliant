//
//  InMemoryListService.m
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InMemoryListService.h"

#import "PersonMemoryCache.h"

@implementation InMemoryListService {
    PersonMemoryCache *_cache;
}

- (id)initWithPersonMemoryCache:(PersonMemoryCache *)cache
{
    self = [super init];
    if (self) {
        _cache = cache;
    }
    return self;
}

- (NSArray *) personList {
    return [[_cache personsByKey] allValues];
}

- (void)addPerson:(Person *)person {
    [_cache addPerson:person];
}

- (void)removePerson:(Person *)person {
    [_cache removePerson:person];
}

- (NSUInteger)countPersons {
    return [_cache personsByKey].count;
}

@end
