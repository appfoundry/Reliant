//
//  OCSPrototypeScopeTests.m
//  Reliant
//
//  Created by Jens Goeman on 21/05/14.
//
//

#import <XCTest/XCTest.h>
#import "OCSPrototypeScope.h"

@interface OCSPrototypeScopeTests : XCTestCase

@end

@implementation OCSPrototypeScopeTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testObjectForKeyShouldAlwaysReturnNil {
    OCSPrototypeScope *prototypeScope = [[OCSPrototypeScope alloc] init];
    id object = [prototypeScope objectForKey:@"theKey"];
    XCTAssertNil(object);
}

- (void)testObjectForKeyShouldReturnNilEvenWhenRegistered {
    OCSPrototypeScope *prototypeScope = [[OCSPrototypeScope alloc] init];
    [prototypeScope registerObject:@"" forKey:@"theKey"];
    id object = [prototypeScope objectForKey:@"theKey"];
    XCTAssertNil(object);

}

@end
