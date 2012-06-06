//
//  InMemoryDetailService.h
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DetailService.h"

@class PersonMemoryCache;

@interface InMemoryDetailService : NSObject<DetailService>

@property (nonatomic, retain) PersonMemoryCache *personMemoryCache;

@end
