//
//  DependencyTreeConfigurationIntegrationTest.m
//  Reliant
//
//  Created by Michael Seghers on 23/08/14.
//
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "OCSApplicationContext.h"
#import "OCSConfiguratorFromClass.h"

@interface DependencyTreeConfigurationIntegrationTest : XCTestCase

@end

@class ClassB;
@class ClassD;

@interface ClassA : NSObject
@property (nonatomic, strong) ClassB *b;
@property (nonatomic, strong) ClassD *d;
@end

@interface ClassB : NSObject
- (instancetype)initWithA:(ClassA *) a;

- (ClassA *)injectedA;
@end

@interface ClassC : NSObject
- (instancetype)initWithB:(ClassB *) b;
@property (nonatomic, strong) ClassA *a;

- (ClassB *)injectedB;
@end

@interface ClassD : NSObject
@property (nonatomic, weak) ClassA *a;
@end



@interface DependencyTreeEagerConfiguration : NSObject 
@end

@interface DependencyTreeLazyConfiguration : NSObject
@end

@interface DependencyTreeLazyAndEagerConfiguration : NSObject
@end



@implementation DependencyTreeConfigurationIntegrationTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEagerLoaded
{
    id <OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[DependencyTreeEagerConfiguration class]];
    OCSApplicationContext *context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];
    [context start];

    ClassA *a = [context objectForKey:@"a"];
    ClassB *b = [context objectForKey:@"b"];
    ClassC *c = [context objectForKey:@"c"];
    ClassD *d = [context objectForKey:@"d"];
    assertThat(a, is(notNilValue()));
    assertThat(b, is(notNilValue()));
    assertThat(c, is(notNilValue()));
    assertThat(d, is(notNilValue()));

    assertThat([b injectedA], is(sameInstance(a)));
    assertThat([c injectedB], is(sameInstance(b)));
    assertThat(d.a, is(sameInstance(a)));
    assertThat(c.a, is(sameInstance(a)));
    assertThat(a.d, is(sameInstance(d)));
}

- (void)testLazyAndEagerLoaded
{
    id <OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[DependencyTreeLazyAndEagerConfiguration class]];
    OCSApplicationContext *context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];
    [context start];

    ClassA *a = [context objectForKey:@"a"];
    ClassB *b = [context objectForKey:@"b"];
    ClassC *c = [context objectForKey:@"c"];
    ClassD *d = [context objectForKey:@"d"];
    assertThat(a, is(notNilValue()));
    assertThat(b, is(notNilValue()));
    assertThat(c, is(notNilValue()));
    assertThat(d, is(notNilValue()));

    assertThat([b injectedA], is(sameInstance(a)));
    assertThat([c injectedB], is(sameInstance(b)));
    assertThat(d.a, is(sameInstance(a)));
    assertThat(c.a, is(sameInstance(a)));
    assertThat(a.d, is(sameInstance(d)));
}

- (void)testLazyLoadFirstLoadingClassA
{
    id <OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[DependencyTreeLazyConfiguration class]];
    OCSApplicationContext *context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];
    [context start];

    ClassA *a = [context objectForKey:@"a"];
    ClassB *b = [context objectForKey:@"b"];
    ClassD *d = [context objectForKey:@"d"];
    assertThat(a, is(notNilValue()));

    assertThat(a.b, is(sameInstance(b)));
    assertThat(b.injectedA, is(sameInstance(a)));
    assertThat(a.d, is(sameInstance(d)));
    assertThat(d.a, is(sameInstance(a)));
}

- (void)testLazyLoadFirstLoadingClassB
{
    id <OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[DependencyTreeLazyConfiguration class]];
    OCSApplicationContext *context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];
    [context start];

    ClassB *b = [context objectForKey:@"b"];
    ClassA *a = [context objectForKey:@"a"];
    assertThat(b, is(notNilValue()));

    assertThat(b.injectedA, is(sameInstance(a)));
    assertThat(a.b, is(sameInstance(b)));
}

- (void)testLazyLoadFirstLoadingClassC
{
    id <OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[DependencyTreeLazyConfiguration class]];
    OCSApplicationContext *context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];
    [context start];

    ClassC *c = [context objectForKey:@"c"];
    ClassA *a = [context objectForKey:@"a"];
    ClassB *b = [context objectForKey:@"b"];
    assertThat(c, is(notNilValue()));

    assertThat(a.b, is(sameInstance(b)));
    assertThat([b injectedA], is(sameInstance(a)));
    assertThat(c.a, is(a));
    assertThat([c injectedB], is(sameInstance(b)));
}

- (void)testLazyLoadFirstLoadingClassD
{
    id <OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[DependencyTreeLazyConfiguration class]];
    OCSApplicationContext *context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];
    [context start];

    ClassD *d = [context objectForKey:@"d"];
    ClassA *a = [context objectForKey:@"a"];
    assertThat(d, is(notNilValue()));

    assertThat(d.a, is(sameInstance(a)));
}



@end


@implementation DependencyTreeEagerConfiguration

- (id)createEagerSingletonA {
    return [[ClassA alloc] init];
}

- (id)createEagerSingletonB {
    return [[ClassB alloc] initWithA:[self createEagerSingletonA]];
}

- (id)createEagerSingletonC {
    return [[ClassC alloc] initWithB:[self createEagerSingletonB]];
}

- (id)createEagerSingletonD {
    return [[ClassD alloc] init];
}


@end

@implementation DependencyTreeLazyConfiguration

- (id)createSingletonA {
    return [[ClassA alloc] init];
}

- (id)createSingletonB {
    return [[ClassB alloc] initWithA:[self createSingletonA]];
}

- (id)createSingletonC {
    return [[ClassC alloc] initWithB:[self createSingletonB]];
}

- (id)createSingletonD {
    return [[ClassD alloc] init];
}


@end

@implementation DependencyTreeLazyAndEagerConfiguration

- (id)createEagerSingletonA {
    return [[ClassA alloc] init];
}

- (id)createSingletonB {
    return [[ClassB alloc] initWithA:[self createEagerSingletonA]];
}

- (id)createSingletonC {
    return [[ClassC alloc] initWithB:[self createSingletonB]];
}

- (id)createEagerSingletonD {
    return [[ClassD alloc] init];
}


@end


@implementation ClassA
@end

@implementation ClassB {
    __weak ClassA *_a;

}
- (instancetype)initWithA:(ClassA *)a {
    self = [super init];
    if (self) {
        _a = a;
    }
    return self;
}

- (ClassA *)injectedA {
    return _a;
}


@end

@implementation ClassC {
    ClassB *_b;

}
- (instancetype)initWithB:(ClassB *)b {
    self = [super init];
    if (self) {
        _b = b;
    }
    return self;
}

- (ClassB *)injectedB {
    return _b;
}


@end

@implementation ClassD {

}

@end