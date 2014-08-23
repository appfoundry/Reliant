//
//  DpendencyTreeConfigurationIntegrationTest.m
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

@interface DpendencyTreeConfigurationIntegrationTest : XCTestCase

@end

@class ClassB;
@class ClassD;

@interface ClassA : NSObject
@property (nonatomic, strong) ClassB *b;
//@property (nonatomic, strong) ClassD *d;
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
@property (nonatomic, strong) ClassA *a;
@end



@interface DependencyTreeEagerConfiguration : NSObject 
@end



@implementation DpendencyTreeConfigurationIntegrationTest

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

    assertThat(a, is(sameInstance([b injectedA])));
    assertThat(b, is(sameInstance([c injectedB])));
    assertThat(a, is(sameInstance(d.a)));
    assertThat(a, is(sameInstance(c.a)));
}

@end


@implementation DependencyTreeEagerConfiguration : NSObject

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


@implementation ClassA
@end

@implementation ClassB {
    ClassA *_a;

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