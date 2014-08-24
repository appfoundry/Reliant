//
//  RecursiveConfiguration.m
//  Reliant
//
//  Created by Michael Seghers on 24/08/14.
//
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND

#import <OCHamcrest/OCHamcrest.h>
#import "OCSApplicationContext.h"
#import "OCSConfiguratorFromClass.h"

@interface RecursiveConfigurationTest : XCTestCase

@end

@class DirectRecursiveB;
@class IndirectRecursiveC;

@interface DirectRecursiveA : NSObject
- (instancetype)initWithDirectRecursiveB:(DirectRecursiveB *)b;
@end


@interface DirectRecursiveB : NSObject
- (instancetype)initWithDirectRecursiveA:(DirectRecursiveA *)a;

- (instancetype)initWithIndirectRecursiveC:(IndirectRecursiveC *)c;
@end

@interface IndirectRecursiveC : NSObject
- (instancetype)initWithIndirectRecursiveA:(DirectRecursiveA *)a;
@end

@interface DirectRecursiveEagerConfiguration : NSObject
@end

@interface DirectRecursiveLazyConfiguration : NSObject
@end

@interface IndirectRecursiveEagerConfiguration : NSObject
@end

@interface IndirectRecursiveLazyConfiguration : NSObject
@end

@implementation RecursiveConfigurationTest

- (void)testEagerDirectRecursionDetection {
    OCSApplicationContext *context = [self _createContextForClass:[DirectRecursiveEagerConfiguration class]];
    [self _expectExceptionWhenExecutingBlock:^{
        [context start];
    }                             withReason:@"Circular dependency detected for the following stack: A -> B -> A"];
}

- (void)testLazyDirectRecursionDetection {
    OCSApplicationContext *context = [self _createContextForClass:[DirectRecursiveLazyConfiguration class]];
    [context start];
    [self _expectExceptionWhenExecutingBlock:^{
        [context objectForKey:@"A"];
    }                             withReason:@"A -> B -> A"];
}

- (void)testEagerIndirectRecursionDetection {
    OCSApplicationContext *context = [self _createContextForClass:[IndirectRecursiveEagerConfiguration class]];
    [self _expectExceptionWhenExecutingBlock:^{
        [context start];
    }                             withReason:@"A -> B -> C -> A"];
}

- (void)testLazyIndirectRecursionDetectionStartingFromA {
    OCSApplicationContext *context = [self _createContextForClass:[IndirectRecursiveLazyConfiguration class]];
    [self _expectExceptionWhenExecutingBlock:^{
        [context objectForKey:@"A"];
    }                             withReason:@"A -> B -> C -> A"];
}

- (void)testLazyIndirectRecursionDetectionStartingFromB {
    OCSApplicationContext *context = [self _createContextForClass:[IndirectRecursiveLazyConfiguration class]];
    [self _expectExceptionWhenExecutingBlock:^{
        [context objectForKey:@"B"];
    }                             withReason:@"B -> C -> A -> B"];
}

- (void)testLazyIndirectRecursionDetectionStartingFromC {
    OCSApplicationContext *context = [self _createContextForClass:[IndirectRecursiveLazyConfiguration class]];
    [self _expectExceptionWhenExecutingBlock:^{
        [context objectForKey:@"C"];
    }                             withReason:@"C -> A -> B -> C"];
}

- (OCSApplicationContext *)_createContextForClass:(Class)configClass {
    id <OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:configClass];
    OCSApplicationContext *context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];
    return context;
}

- (void)_expectExceptionWhenExecutingBlock:(void (^)())block withReason:(NSString *)reason {
    BOOL thrown = NO;
    @try {
        block();
    } @catch (NSException *e) {
        thrown = YES;
        assertThat(e.name, is(equalTo(@"ReliantCircularDependencyException")));
        assertThat(e.reason, is(containsString(reason)));
    }

    assertThatBool(thrown, is(equalToBool(YES)));
}

@end

@implementation DirectRecursiveA
- (instancetype)initWithDirectRecursiveB:(DirectRecursiveB *)b {
    return nil;
}

@end

@implementation DirectRecursiveB
- (instancetype)initWithDirectRecursiveA:(DirectRecursiveA *)a {
    return nil;
}

- (instancetype)initWithIndirectRecursiveC:(IndirectRecursiveC *)c {
    return nil;
}

@end


@implementation DirectRecursiveEagerConfiguration

- (id)createEagerSingletonA {
    return [[DirectRecursiveA alloc] initWithDirectRecursiveB:[self createEagerSingletonB]];
}

- (id)createEagerSingletonB {
    return [[DirectRecursiveB alloc] initWithDirectRecursiveA:[self createEagerSingletonA]];
}

@end

@implementation DirectRecursiveLazyConfiguration

- (id)createSingletonA {
    return [[DirectRecursiveA alloc] initWithDirectRecursiveB:[self createSingletonB]];
}

- (id)createSingletonB {
    return [[DirectRecursiveB alloc] initWithDirectRecursiveA:[self createSingletonA]];
}

@end

@implementation IndirectRecursiveEagerConfiguration

- (id)createEagerSingletonA {
    return [[DirectRecursiveA alloc] initWithDirectRecursiveB:[self createEagerSingletonB]];
}

- (id)createEagerSingletonB {
    return [[DirectRecursiveB alloc] initWithIndirectRecursiveC:[self createEagerSingletonC]];
}

- (id)createEagerSingletonC {
    return [[IndirectRecursiveC alloc] initWithIndirectRecursiveA:[self createEagerSingletonA]];
}

@end

@implementation IndirectRecursiveLazyConfiguration

- (id)createSingletonA {
    return [[DirectRecursiveA alloc] initWithDirectRecursiveB:[self createSingletonB]];
}

- (id)createSingletonB {
    return [[DirectRecursiveB alloc] initWithIndirectRecursiveC:[self createSingletonC]];
}

- (id)createSingletonC {
    return [[IndirectRecursiveC alloc] initWithIndirectRecursiveA:[self createSingletonA]];
}


@end

@implementation IndirectRecursiveC

- (instancetype)initWithIndirectRecursiveA:(DirectRecursiveA *)a {
    return nil;
}

@end