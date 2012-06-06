//
//  ReliantDemoFactory.m
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReliantDemoFactory.h"
#import "InMemoryListService.h"
#import "InMemoryDetailService.h"
#import "PersonMemoryCache.h"
#import "ControllerTracker.h"

@implementation ReliantDemoFactory

- (PersonMemoryCache *) createSingletonPersonMemoryCache {
    NSLog(@"Creating person cache");
    return [[PersonMemoryCache alloc] init];
}

- (id<DetailService>) createSingletonDetailService {
    NSLog(@"Creating detail service");
    return [[InMemoryDetailService alloc] init];
}

- (id<ListService>) createEagerSingletonlistService {
    NSLog(@"Creating list service");
    return [[InMemoryListService alloc] initWithPersonMemoryCache:[self createSingletonPersonMemoryCache]];
}

- (id) createPrototypeControllerTracker {
    NSLog(@"Creating controller tracker");
    return [[ControllerTracker alloc] init];
}

- (NSArray *) aliasesForDetailService {
    NSLog(@"Retruning aliases for detail service");
    return [NSArray arrayWithObjects:@"couchPatatoe", @"lazyJoe", nil];
}

@end
