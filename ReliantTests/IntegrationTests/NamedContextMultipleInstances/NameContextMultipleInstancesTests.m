 //
//  NameContextMultipleInstancesTests.m
//  Reliant
//
//  Created by Alex Manarpies on 13/12/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "OCSObjectContext.h"
#import "NSObject+OCSReliantContextBinding.h"
#import "NCMIConfiguration.h"
#import "NCMIChildConfiguration.h"
#import "NCMIGrandChildConfiguration.h"

@interface NameContextMultipleInstancesTests : XCTestCase
@end

@interface NCMIMultipleContextHoldingObject : NSObject

@property(nonatomic, readonly, strong) id<OCSObjectContext> rootContext;
@property(nonatomic, readonly, strong) id<OCSObjectContext> intermediateContext;

@end

@implementation NameContextMultipleInstancesTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testMultipleInstances {
    UIViewController *viewControllerA = [[UIViewController alloc] init];
    viewControllerA.title = @"ViewController A";

    // These are the context holding objects
    UIViewController *viewControllerB = [[UIViewController alloc] init];
    viewControllerB.title = @"ViewController B";

    // Bootstrap the first two contexts, independently from each other
    // Purposefully registering the A last to rule out ordering
    [viewControllerB ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIConfiguration class]];
    [viewControllerA ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIConfiguration class]];

    // Contexts should be different
    assertThat(viewControllerA.ocsObjectContext, isNot(sameInstance(viewControllerB.ocsObjectContext)));

    // Objects requested from either context should be different
    assertThat([viewControllerA.ocsObjectContext objectForKey:@"testObject"], isNot(sameInstance([viewControllerB.ocsObjectContext objectForKey:@"testObject"])));

    // Context 3 derives from NCMIConfiguration
    UIViewController *viewControllerC = [[UIViewController alloc] init];
    viewControllerC.title = @"ViewController C";

    [viewControllerB addChildViewController:viewControllerC];
    [viewControllerC ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIChildConfiguration class]];

    // Derived testObject should be fetched from its parent;
    // In the current system, the parent will be the last context bootstrapped, which can be variable at runtime
    assertThat([viewControllerC.ocsObjectContext objectForKey:@"testObject"], sameInstance([viewControllerB.ocsObjectContext objectForKey:@"testObject"]));
    assertThat([viewControllerC.ocsObjectContext objectForKey:@"testObject"], isNot(sameInstance([viewControllerA.ocsObjectContext objectForKey:@"testObject"])));
}

- (void)testGrandChildShouldBeAbleToLocateGrandParentContext {
    UIViewController *viewControllerA1 = [[UIViewController alloc] init];
    viewControllerA1.title = @"ViewController A1";
    
    UIViewController *viewControllerA2 = [[UIViewController alloc] init];
    viewControllerA2.title = @"ViewController A2";
    
    UIViewController *viewControllerB1 = [[UIViewController alloc] init];
    viewControllerB1.title = @"ViewController B1 -> A1";
    
    UIViewController *viewControllerB2 = [[UIViewController alloc] init];
    viewControllerB2.title = @"ViewController B2 -> A2";
    
    UIViewController *viewControllerC1 = [[UIViewController alloc] init];
    viewControllerC1.title = @"ViewController C1 -> B1";
    
    UIViewController *viewControllerC2 = [[UIViewController alloc] init];
    viewControllerC2.title = @"ViewController C2 -> B2";
    
    [viewControllerA1 addChildViewController:viewControllerB1];
    [viewControllerA2 addChildViewController:viewControllerB2];
    [viewControllerB1 addChildViewController:viewControllerC1];
    [viewControllerB2 addChildViewController:viewControllerC2];
    
    [viewControllerA1 ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIConfiguration class]];
    [viewControllerA2 ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIConfiguration class]];
    [viewControllerB1 ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIChildConfiguration class]];
    [viewControllerB2 ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIChildConfiguration class]];
    [viewControllerC1 ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIGrandChildConfiguration class]];
    [viewControllerC2 ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIGrandChildConfiguration class]];
    
    assertThat([viewControllerC1.ocsObjectContext objectForKey:@"testObject"], sameInstance([viewControllerA1.ocsObjectContext objectForKey:@"testObject"]));
    assertThat([viewControllerC2.ocsObjectContext objectForKey:@"testObject"], sameInstance([viewControllerA2.ocsObjectContext objectForKey:@"testObject"]));
}

- (void)testDoingTheSameTestAFewTimesWoks {
    for (int i = 0; i < 5; i++) {
        [self testGrandChildShouldBeAbleToLocateGrandParentContext];
    }
}

- (void)testObjectsBindingMultipleContextsWithHierarchyWorks {
    NCMIMultipleContextHoldingObject *obj = [[NCMIMultipleContextHoldingObject alloc] init];
    assertThat([obj.ocsObjectContext objectForKey:@"testObject"], is(sameInstance([obj.rootContext objectForKey:@"testObject"])));
}

@end

@implementation NCMIMultipleContextHoldingObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _rootContext = [[OCSObjectContext alloc] initWithConfigurator:[[OCSConfiguratorFromClass alloc] initWithClass:[NCMIConfiguration class]] boundObject:self];
        [_rootContext start];
        _intermediateContext = [[OCSObjectContext alloc] initWithConfigurator:[[OCSConfiguratorFromClass alloc] initWithClass:[NCMIChildConfiguration class]] boundObject:self];
        [_rootContext start];
        [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIGrandChildConfiguration class]];
    }
    return self;
}

@end
