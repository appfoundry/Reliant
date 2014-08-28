//
//  NSObject+OCSReliantInjectionTest.m
//  Reliant
//
//  Created by Michael Seghers on 28/08/14.
//
//

#import <XCTest/XCTest.h>
#import "OCSBoundContextLocatorFactory.h"
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "NSObject+OCSReliantInjection.h"
#import "OCSBoundContextLocator.h"
#import "OCSObjectContext.h"


@interface NSObject_OCSReliantInjectionTest : XCTestCase

@end

@implementation NSObject_OCSReliantInjectionTest {
    id<OCSBoundContextLocator> _contextLocator;
}

- (void)setUp {
    [super setUp];
    OCSBoundContextLocatorFactory *factory = [OCSBoundContextLocatorFactory sharedBoundContextLocatorFactory];
    _contextLocator = mockProtocol(@protocol(OCSBoundContextLocator));
    factory.contextLocator = _contextLocator;
}

- (void)tearDown {
    OCSBoundContextLocatorFactory *factory = [OCSBoundContextLocatorFactory sharedBoundContextLocatorFactory];
    factory.contextLocator = nil;
}

- (void)testShouldCallContextLocatorToLookForContextPassingSelf {
    [self ocsInject];
    [verify(_contextLocator) locateBoundContextForObject:self];
}

- (void)testShouldCallPerformInjectionOnLocatedContext {
    OCSObjectContext *context = mockProtocol(@protocol(OCSObjectContext));
    [given([_contextLocator locateBoundContextForObject:self]) willReturn:context];
    [self ocsInject];
    [verify(context) performInjectionOn:self];
}


@end
