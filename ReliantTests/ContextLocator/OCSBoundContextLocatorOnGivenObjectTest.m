//
//  OCSBoundContextLocatorOnGivenObjectTest.m
//  Reliant
//
//  Created by Michael Seghers on 24/08/14.
//
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "OCSBoundContextLocatorOnGivenObject.h"
#import "OCSObjectContext.h"
#import "NSObject+OCSReliantContextBinding.h"

@interface OCSBoundContextLocatorOnGivenObjectTest : XCTestCase

@end

@implementation OCSBoundContextLocatorOnGivenObjectTest {
    OCSBoundContextLocatorOnGivenObject *_locator;
}

- (void)setUp {
    [super setUp];
    _locator = [[OCSBoundContextLocatorOnGivenObject alloc] init];
}

- (void)testLocatesBoundContextOnSelf {
    id <OCSObjectContext> context = mockProtocol(@protocol(OCSObjectContext));
    self.ocsObjectContext = context;
    assertThat([_locator locateBoundContextForObject:self], is(sameInstance(context)));
}


- (void)testReturnsNilIfNoContextFoundOnSelf {
    assertThat([_locator locateBoundContextForObject:self], is(nilValue()));
}

@end
