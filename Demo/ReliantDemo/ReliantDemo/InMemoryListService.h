//
//  InMemoryListService.h
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ListService.h"

@class PersonMemoryCache;

@interface InMemoryListService : NSObject<ListService>

- (id) initWithPersonMemoryCache:(PersonMemoryCache *) cache;

@end
