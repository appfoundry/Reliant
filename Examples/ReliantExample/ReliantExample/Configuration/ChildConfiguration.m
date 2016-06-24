//
//  ChildConfiguration.m
//  ReliantExample
//
//  Created by Michael Seghers on 24/06/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

#import "ChildConfiguration.h"
#import "RandomizedColorService.h"

@implementation ChildConfiguration

- (id<ColorService>)createSingletonColorService {
    return [[RandomizedColorService alloc] init];
}

@end
