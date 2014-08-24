//
//  OCSBoundContextLocatorOnSelfTest.m
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
#import "OCSBoundContextLocatorOnSelf.h"
#import "OCSObjectContext.h"
#import "NSObject+OCSReliantContextBinding.h"

@interface OCSBoundContextLocatorOnSelfTest : XCTestCase

@end

@implementation OCSBoundContextLocatorOnSelfTest {
    OCSBoundContextLocatorOnSelf *_locator;
}

- (void)setUp {
    [super setUp];
    _locator = [[OCSBoundContextLocatorOnSelf alloc] init];
}

- (void)testCanLocateForAnyObject {
    assertThatBool([_locator canLocateBoundContextForObject:self], is(equalToBool(YES)));
}

- (void)testLocatesBoundContextOnSelf {
    id <OCSObjectContext> context = mockProtocol(@protocol(OCSObjectContext));
    self.ocsObjectContext = context;
    assertThat([_locator locateBoundContextForObject:self], is(sameInstance(context)));
}


- (void)testReturnsNilOfNoContextFoundOnSelf {
    assertThat([_locator locateBoundContextForObject:self], is(nilValue()));
}

@end
