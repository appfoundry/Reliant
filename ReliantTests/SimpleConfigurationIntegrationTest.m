//
//  IntegrationTest.m
//  Reliant
//
//  Created by Michael Seghers on 23/08/14.
//
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "OCSApplicationContext.h"
#import "OCSConfigurator.h"
#import "OCSConfiguratorFromClass.h"
#import "OCSScopeFactory.h"

@interface SimpleConfigurationIntegrationTest : XCTestCase

@end

@interface SimpleConfiguration : NSObject

- (id)createEagerSingletonTest;
- (id)createSingletonLazy;
- (id)createPrototypeProto;

@end

@implementation SimpleConfigurationIntegrationTest {
    OCSApplicationContext *_context;
}

- (void)setUp {
    [super setUp];
    id<OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[SimpleConfiguration class]];
    _context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];
    [_context start];
}

- (void)testScopeHasTestObjectAfterStart {
    id <OCSScope> singletonScope = [_context.scopeFactory scopeForName:@"singleton"];
    assertThat([singletonScope objectForKey:@"Test"], is(equalTo(@"test")));
}

- (void)testScopeDoesNotHaveLazyObjectAfterStart {
    id <OCSScope> singletonScope = [_context.scopeFactory scopeForName:@"singleton"];
    assertThat([singletonScope objectForKey:@"Lazy"], is(nilValue()));
}

- (void)testObjectForKeyReturnsLazyObject {
    id result = [_context objectForKey:@"Lazy"];
    id <OCSScope> singletonScope = [_context.scopeFactory scopeForName:@"singleton"];
    assertThat([singletonScope objectForKey:@"Lazy"], is(notNilValue()));
    assertThat(result, is(sameInstance([singletonScope objectForKey:@"Lazy"])));
}

- (void)testObjectForKeyAlwaysReturnsSameInstanceForSingletonScope {
    id firstTime = [_context objectForKey:@"Test"];
    id secondTime = [_context objectForKey:@"Test"];
    assertThat(firstTime, is(sameInstance(secondTime)));
}

- (void)testObjectForKeyAlwaysReturnsNewInstanceForPrototypeScope {
    id firstTime = [_context objectForKey:@"Proto"];
    id secondTime = [_context objectForKey:@"Proto"];
    assertThat(firstTime, isNot(sameInstance(secondTime)));
}

@end


@implementation SimpleConfiguration

- (id)createEagerSingletonTest {
    return @"test";
}

- (id)createSingletonLazy {
    return [[NSObject alloc] init];
}

- (id)createPrototypeProto {
    return [[NSObject alloc] init];
}

@end
