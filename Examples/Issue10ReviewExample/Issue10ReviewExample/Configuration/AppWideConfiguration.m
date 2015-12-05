//
// Created by Alex Manarpies on 05/12/15.
// Copyright (c) 2015 Reliant. All rights reserved.
//

#import "AppWideConfiguration.h"
#import "FibonacciViewModel.h"

@implementation AppWideConfiguration

- (FibonacciViewModel *)createSingletonFibonacciViewModel {
    return [[FibonacciViewModel alloc] init];
}

@end