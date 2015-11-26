//
//  OCSObjectContextWithParentTests.m
//  Reliant
//
//  Created by Michael Seghers on 26/11/15.
//
//

#import <XCTest/XCTest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import <objc/runtime.h>

#import "OCSObjectContext.h"
#import "OCSConfigurator.h"


@interface OCSObjectContextWithParentTests : XCTestCase {
    id<OCSConfigurator> _configurator;
    id<OCSObjectContext> _parentContext;
    OCSObjectContext *_context;
}

@end

@implementation OCSObjectContextWithParentTests

- (void)setUp {
    [super setUp];
    _configurator = mockProtocol(@protocol(OCSConfigurator));
    _parentContext = mockProtocol(@protocol(OCSObjectContext));
    _context = [[OCSObjectContext alloc] initWithConfigurator:_configurator parentContext:_parentContext];
}

- (void)testShouldInitializeWhenPassingNilParentContext {
    OCSObjectContext *oc = [[OCSObjectContext alloc] initWithConfigurator:_configurator parentContext:nil];
    assertThat(oc, is(notNilValue()));
    assertThat(oc.parentContext, is(nilValue()));
}


- (void)testParentContextIsConsultedWhenObjectNotFoundOnOwnContext {
    [_context objectForKey:@"someObjectName"];
    [verify(_parentContext) objectForKey:@"someObjectName"];
}

- (void)testParentContextPerformInjectionIsAlsoCalledWhenPerformingInjectionViaChildContext {
    id object = [[NSObject alloc] init];
    [_context performInjectionOn:object];
    [verify(_parentContext) performInjectionOn:object];
}

@end
