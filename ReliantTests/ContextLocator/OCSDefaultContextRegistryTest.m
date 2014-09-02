//
//  OCSDefaultContextRegistryTest.m
//  Reliant
//
//  Created by Michael Seghers on 01/09/14.
//
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "OCSDefaultContextRegistry.h"
#import "OCSObjectContext.h"

@interface OCSDefaultContextRegistryTest : XCTestCase

@end

@implementation OCSDefaultContextRegistryTest {
    OCSDefaultContextRegistry *_registry;
    id<OCSObjectContext> _context;
}

- (void)setUp {
    [super setUp];
    _registry = [[OCSDefaultContextRegistry alloc] init];
    _context = mockProtocol(@protocol(OCSObjectContext));
}

- (void)testRegisteredObjectContextCanBeRetrievedByItsName {
    [given(_context.name) willReturn:@"name"];
    [_registry registerContext:_context];
    assertThat([_registry contextForName:@"name"], is(sameInstance(_context)));
}

- (void)testRegisterReturnsNilForUnknownContexts {
    [given(_context.name) willReturn:@"name"];
    [_registry registerContext:_context];
    assertThat([_registry contextForName:@"unknown"], is(nilValue()));
}

- (void)testRegisterShouldHoldWeakReferencesToContexts {
    @autoreleasepool {
        id<OCSObjectContext> context = mockProtocol(@protocol(OCSObjectContext));
        [given(context.name) willReturn:@"name"];
        __weak id<OCSObjectContext> weakContext = context;
        [_registry registerContext:weakContext];
    }
    assertThat([_registry contextForName:@"name"], is(nilValue()));
}

- (void)testSharedInstanceIsSingleton {
    assertThat([OCSDefaultContextRegistry sharedDefaultContextRegistry], is(sameInstance([OCSDefaultContextRegistry sharedDefaultContextRegistry])));
}

@end
