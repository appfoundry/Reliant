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
#import "NSObject+OCSReliantContextBinding.h"

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

- (void)testCanLocateForAnyObject {
    assertThatBool([_locator canLocateBoundContextForObject:self], is(equalToBool(YES)));
}

- (void)testLocatesBoundOnLocatorThatApplies {
    [given([_first canLocateBoundContextForObject:anything()]) willReturnBool:YES];
    [given([_second canLocateBoundContextForObject:anything()]) willReturnBool:NO];
    [given([_third canLocateBoundContextForObject:anything()]) willReturnBool:YES];

    id <OCSObjectContext> context = [_locator locateBoundContextForObject:self];
    assertThat(context, is(nilValue()));

    [verify(_first) locateBoundContextForObject:self];
    [verify(_third) locateBoundContextForObject:self];
    [verifyCount(_second, never()) locateBoundContextForObject:self];
}

- (void)testLocatingStopsAfterContextIsFound {
    [given([_first canLocateBoundContextForObject:anything()]) willReturnBool:YES];
    [given([_first locateBoundContextForObject:anything()]) willReturn:_context];

    id <OCSObjectContext> context = [_locator locateBoundContextForObject:self];
    assertThat(context, is(sameInstance(_context)));

    [verifyCount(_second, never()) locateBoundContextForObject:anything()];
    [verifyCount(_second, never()) canLocateBoundContextForObject:anything()];
    [verifyCount(_third, never()) locateBoundContextForObject:anything()];
    [verifyCount(_third, never()) canLocateBoundContextForObject:anything()];
}

@end
