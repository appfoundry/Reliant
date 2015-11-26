//
//  UnfriendlyGreeterTest.m
//  HelloReliant
//
//  Created by Michael Seghers on 26/11/15.
//  Copyright © 2015 AppFoundry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UnfriendlyGreeter.h"

@interface UnfriendlyGreeterTest : XCTestCase {
    UnfriendlyGreeter *_greeter;
}


@end

@implementation UnfriendlyGreeterTest

- (void)setUp {
    [super setUp];
    _greeter = [[UnfriendlyGreeter alloc] init];
}

- (void)testGreetsFriendlyToName {
    XCTAssertEqualObjects([_greeter sayHelloTo:@"Reliant"], @"Computer says no...");
}

@end
