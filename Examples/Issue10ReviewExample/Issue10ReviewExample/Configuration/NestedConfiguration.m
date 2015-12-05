//
// Created by Alex Manarpies on 05/12/15.
// Copyright (c) 2015 Reliant. All rights reserved.
//

#import "NestedConfiguration.h"
#import "RandomViewModel.h"

@implementation NestedConfiguration

- (RandomViewModel *)createSingletonRandomViewModel {
    return [[RandomViewModel alloc] init];
}

@end