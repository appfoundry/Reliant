//
// Created by Alex Manarpies on 05/12/15.
// Copyright (c) 2015 Reliant. All rights reserved.
//

#import "FibonacciViewModel.h"

@implementation FibonacciViewModel

- (NSString *)fibonacciSequenceOfLength:(NSUInteger)length {
    long i; // used in the "for" loop
    long long f1 = 1; // seed value 1
    long long f2 = 0; // seed value 2
    long long fn; // used as a holder for each new value in the loop

    NSMutableString *string = [[NSMutableString alloc] init];
    for (i = 1; i < length; i++) {
        fn = f1 + f2;
        f1 = f2;
        f2 = fn;
        [string appendFormat:@"%@%lli", i == 1 ? @"" : @", ", fn];
    }

    return string;
}

@end