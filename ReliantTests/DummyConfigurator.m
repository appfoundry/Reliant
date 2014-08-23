//
//  DummyConfigurator.m
//  Reliant
//
//  Created by Michael Seghers on 29/10/13.
//
//

#import "DummyConfigurator.h"
#import "TestObject.h"

@class CircularClassB;

@interface CircularClassA : NSObject
- (id)initWithB:(CircularClassB *)classB;
@end

@interface CircularClassB : NSObject
- (id)initWithA:(CircularClassA *)classA;
@end


@implementation DummyConfigurator

- (NSObject *) createEagerSingletonVerySmartName {
    return [[NSObject alloc] init];
}

- (TestObject *) createEagerSingletonNeverInjectedByOthers {
    return [[TestObject alloc] init];
}

- (NSArray *) aliasesForVerySmartName {
    return [NSArray arrayWithObjects:@"aliasForVerySmartName", @"justAnotherNameForVerySmartName", nil];
}

- (NSArray *) createPrototypeUnbelievableOtherSmartName {
    return [[NSMutableArray alloc] init];
}

- (NSDictionary *) createSingletonLazyOne {
    return [[NSMutableDictionary alloc] init];
}

- (ObjectWithInjectables *) createEagerSingletonSuper {
    return [[ObjectWithInjectables alloc] initWithVerySmartName:[self createEagerSingletonVerySmartName]];
}

- (ExtendedObjectWithInjectables *) createEagerSingletonExtended {
    return [[ExtendedObjectWithInjectables alloc] init];
}

- (id)createEagerSingletonCircularClassA {
    return [[CircularClassA alloc] initWithB:[self createEagerSingletonCircularClassB]];
}

- (id)createEagerSingletonCircularClassB {
    return [[CircularClassB alloc] initWithA:[self createEagerSingletonCircularClassA]];
}

- (id) createWithBadName {
    return @"WRONG";
}


- (id) createSingletonSomeObjectWithSuper:(ObjectWithInjectables *) someSuper andExtended:(ExtendedObjectWithInjectables *) extended {
    return @"WRONG AGAIN";
}

- (id) createPrototypeWithParameter:(id) param {
    return @"WRONG AGAIN AGAIN";
}

@end

@implementation ObjectWithInjectables

@synthesize verySmartName;

- (id) initWithVerySmartName:(NSObject *)averySmartName {
    self = [super init];
    if (self) {
        verySmartName = averySmartName;
    }
    return self;
}

@end


@implementation ExtendedObjectWithInjectables

@synthesize unbelievableOtherSmartName;

@end

@implementation CircularClassA

- (id)initWithB:(CircularClassB *)classB {
    return nil;
}

@end

@implementation CircularClassB

- (id)initWithA:(CircularClassA *)classA {
    return nil;
}


@end