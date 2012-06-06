//
//  InMemoryDetailService.m
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InMemoryDetailService.h"

#import "PersonMemoryCache.h"

@implementation InMemoryDetailService {
    PersonMemoryCache *_cache;
}

@synthesize personMemoryCache = _cache;

- (Person *)personForKey:(NSString *)key {
    return [[_cache personsByKey] objectForKey:key];
}

@end
