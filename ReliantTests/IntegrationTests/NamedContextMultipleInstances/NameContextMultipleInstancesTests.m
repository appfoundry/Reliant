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

@interface NameContextMultipleInstancesTests : XCTestCase
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

@end
