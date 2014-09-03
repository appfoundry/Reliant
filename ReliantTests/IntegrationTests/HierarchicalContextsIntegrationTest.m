//
//  HierarchicalContextsIntegrationTest.m
//  Reliant
//
//  Created by Michael Seghers on 24/08/14.
//
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "OCSObjectContext.h"
#import "OCSConfiguratorFromClass.h"

@interface HierarchicalContextsIntegrationTest : XCTestCase

@end

@interface ParentConfiguration : NSObject
@end

@interface ChildConfiguration : NSObject<OCSConfigurationClass>
@end

@interface HierarchicalInjected : NSObject
@property (nonatomic, strong) NSString *a;
@property (nonatomic, strong) NSString *b;
@property (nonatomic, strong) NSString *c;
@end

@implementation HierarchicalContextsIntegrationTest {
    OCSObjectContext *_parentContext;
    OCSObjectContext *_childContext;
}

- (void)setUp {
    [super setUp];
    id <OCSConfigurator> parentConfigurator = [[OCSConfiguratorFromClass alloc] initWithClass:[ParentConfiguration class]];
    _parentContext = [[OCSObjectContext alloc] initWithConfigurator:parentConfigurator];

    id <OCSConfigurator> childConfigurator = [[OCSConfiguratorFromClass alloc] initWithClass:[ChildConfiguration class]];
    _childContext = [[OCSObjectContext alloc] initWithConfigurator:childConfigurator];
}

- (void)testInjectionForAFromChildContext {
    HierarchicalInjected *hi = [[HierarchicalInjected alloc] init];
    [_childContext performInjectionOn:hi];
    assertThat(hi.a, is(equalTo(@"A")));
}

- (void)testInjectionForBFromChildContext {
    HierarchicalInjected *hi = [[HierarchicalInjected alloc] init];
    [_childContext performInjectionOn:hi];
    assertThat(hi.b, is(equalTo(@"B")));
}

- (void)testInjectionForCFromChildContext {
    HierarchicalInjected *hi = [[HierarchicalInjected alloc] init];
    [_childContext performInjectionOn:hi];
    assertThat(hi.c, is(equalTo(@"Child C")));
}

- (void)testInjectionForAFromParentContext {
    HierarchicalInjected *hi = [[HierarchicalInjected alloc] init];
    [_parentContext performInjectionOn:hi];
    assertThat(hi.a, is(equalTo(@"A")));
}

- (void)testInjectionForBFromParentContext {
    HierarchicalInjected *hi = [[HierarchicalInjected alloc] init];
    [_parentContext performInjectionOn:hi];
    assertThat(hi.b, is(nilValue()));
}

- (void)testInjectionForCFromParentContext {
    HierarchicalInjected *hi = [[HierarchicalInjected alloc] init];
    [_parentContext performInjectionOn:hi];
    assertThat(hi.c, is(equalTo(@"Parent C")));
}

@end

@implementation ParentConfiguration

- (id) createEagerSingletonA {
    return @"A";
}

- (id) createEagerSingletonC {
    return @"Parent C";
}

@end

@implementation ChildConfiguration
- (id) createEagerSingletonB {
    return @"B";
}

- (id) createEagerSingletonC {
    return @"Child C";
}

- (Class)parentContextConfiguratorClass {
    return [ParentConfiguration class];
}

@end

@implementation HierarchicalInjected
@end
