//
//  OCSPrototypeScopeTests.m
//  Reliant
//
//  Created by Jens Goeman on 21/05/14.
//
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "OCSPrototypeScope.h"

@interface OCSPrototypeScopeTests : XCTestCase

@end

@implementation OCSPrototypeScopeTests {
    OCSPrototypeScope *_prototypeScope;
}

- (void)setUp {
    [super setUp];
    _prototypeScope = [[OCSPrototypeScope alloc] init];
}

- (void)testObjectForKeyShouldAlwaysReturnNil {
    id object = [_prototypeScope objectForKey:@"theKey"];
    assertThat(object, is(nilValue()));
}

- (void)testObjectForKeyShouldReturnNilEvenWhenRegistered {
    [_prototypeScope registerObject:@"" forKey:@"theKey"];
    id object = [_prototypeScope objectForKey:@"theKey"];
    (object, is(nilValue()));
}

- (void)testAllKeysReturnsEmptyArray {
    assertThat([_prototypeScope allKeys], hasCountOf(0));
}

@end
