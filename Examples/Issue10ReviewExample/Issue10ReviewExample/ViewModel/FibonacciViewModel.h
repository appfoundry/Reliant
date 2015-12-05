//
// Created by Alex Manarpies on 05/12/15.
// Copyright (c) 2015 Reliant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FibonacciViewModel : NSObject

/**
 * Returns a Fibonacci sequence of a given length as a string.
 */
- (NSString *)fibonacciSequenceOfLength:(NSUInteger)length;

@end