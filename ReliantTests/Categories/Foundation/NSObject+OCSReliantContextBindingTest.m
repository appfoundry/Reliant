//
//  Test.m
//  Reliant
//
//  Created by Michael Seghers on 24/08/14.
//
//

#import <XCTest/XCTest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "OCSConfigurator.h"
#import "OCSObjectContext.h"
#import "NSObject+OCSReliantContextBinding.h"

@interface NSObject_OCSReliantContextBindingTest : XCTestCase

@end

static BOOL hasCalledEagerMethodAndThusContextWasBootstrapped = NO;

@interface BootstrappedConfigurationClass : NSObject



@end

@implementation NSObject_OCSReliantContextBindingTest {
    id <OCSObjectContext> _parentContext;
}

- (void)setUp {
    [super setUp];
    _parentContext = mockProtocol(@protocol(OCSObjectContext));
}

- (void)tearDown {
    hasCalledEagerMethodAndThusContextWasBootstrapped = NO;
}

- (void)testBindContextAssociatesContextWithObject {
    NSObject *object = [[NSObject alloc] init];
    OCSObjectContext *context = mock([OCSObjectContext class]);
    object.ocsObjectContext = context;
    assertThat(object.ocsObjectContext, is(sameInstance(context)));
}

- (void)testBootstrapAndBindContextWithConfiguratorFromClass {
    NSObject *object = [[NSObject alloc] init];
    [object ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[BootstrappedConfigurationClass class]];
    assertThat(object.ocsObjectContext, is(notNilValue()));
    assertThatBool(hasCalledEagerMethodAndThusContextWasBootstrapped, isTrue());
}

- (void)testBootstrapAndBindContextWithConfiguratorFromClassWithParentContext {
    NSObject *object = [[NSObject alloc] init];
    [object ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[BootstrappedConfigurationClass class] parentContext:_parentContext];
    assertThat(object.ocsObjectContext, is(notNilValue()));
    assertThatBool(hasCalledEagerMethodAndThusContextWasBootstrapped, isTrue());
    assertThat(object.ocsObjectContext.parentContext, is(sameInstance(_parentContext)));
}

@end


@implementation BootstrappedConfigurationClass

- (id)createEagerSingletonA {
    hasCalledEagerMethodAndThusContextWasBootstrapped = YES;
    return @"";
}

@end