//
//  OCSBoundContextLocatorChainTest.m
//  Reliant
//
//  Created by Michael Seghers on 25/08/14.
//
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "OCSBoundContextLocatorChain.h"
#import "OCSObjectContext.h"

@interface OCSBoundContextLocatorChainTest : XCTestCase

@end

@implementation OCSBoundContextLocatorChainTest {
    OCSBoundContextLocatorChain *_locator;
    id<OCSBoundContextLocator> _first;
    id<OCSBoundContextLocator> _second;
    id<OCSBoundContextLocator> _third;
    id<OCSObjectContext> _context;
}

- (void)setUp {
    [super setUp];
    _locator = [[OCSBoundContextLocatorChain alloc] init];
    _first = mockProtocol(@protocol(OCSBoundContextLocator));
    _second = mockProtocol(@protocol(OCSBoundContextLocator));
    _third = mockProtocol(@protocol(OCSBoundContextLocator));
    [_locator addBoundContextLocator:_first];
    [_locator addBoundContextLocator:_second];
    [_locator addBoundContextLocator:_third];
    _context = mockProtocol(@protocol(OCSObjectContext));
}


- (void)testLocatingStopsAfterContextIsFound {
    [given([_second locateBoundContextForObject:anything()]) willReturn:_context];

    id <OCSObjectContext> context = [_locator locateBoundContextForObject:self];
    assertThat(context, is(sameInstance(_context)));

    [verify(_first) locateBoundContextForObject:anything()];
    [verify(_second) locateBoundContextForObject:anything()];
    [verifyCount(_third, never()) locateBoundContextForObject:anything()];
}

@end
