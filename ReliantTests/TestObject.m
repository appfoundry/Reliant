//
//  TestObject.m
//  Reliant
//
//  Created by Michael Seghers on 29/10/13.
//
//

#import "TestObject.h"

@implementation TestObject

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"i");
    }
    return self;
}

- (void)dealloc {
    NSLog(@"d");
}

- (NSString *)description {
    return @"test";
}

@end
