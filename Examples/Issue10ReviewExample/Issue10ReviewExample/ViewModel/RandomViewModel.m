//
// Created by Alex Manarpies on 05/12/15.
// Copyright (c) 2015 Reliant. All rights reserved.
//

#import "RandomViewModel.h"

@implementation RandomViewModel

- (NSInteger)number {
    return _number ?: (_number = arc4random_uniform(74));
}

@end