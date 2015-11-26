//
//  FriendlyGreeterTest.m
//  HelloReliant
//
//  Created by Michael Seghers on 26/11/15.
//  Copyright © 2015 AppFoundry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FriendlyGreeter.h"

@interface FriendlyGreeterTest : XCTestCase {
    FriendlyGreeter *_greeter;
}

@end

@implementation FriendlyGreeterTest

- (void)setUp {
    [super setUp];
    _greeter = [[FriendlyGreeter alloc] init];
}

- (void)testGreetsFriendlyToName {
    XCTAssertEqualObjects([_greeter sayHelloTo:@"Reliant"], @"Hi, Reliant! How are you?");
}

@end
