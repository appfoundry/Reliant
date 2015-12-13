 //
//  NameContextMultipleInstancesTests.m
//  Reliant
//
//  Created by Alex Manarpies on 13/12/15.
//
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>

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
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMultipleInstances {
    // These are the context holding objects
    NSObject *contextHoldingObject1 = [[NSObject alloc] init];
    NSObject *contextHoldingObject2 = [[NSObject alloc] init];

    // Bootstrap the first two contexts, independently from eachother
    [contextHoldingObject1 ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIConfiguration class]];
    [contextHoldingObject2 ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIConfiguration class]];

    // Contexts should be different
    expect(contextHoldingObject1.ocsObjectContext).notTo.beIdenticalTo(contextHoldingObject2.ocsObjectContext);

    // Objects requested from either context should be different
    expect([contextHoldingObject1.ocsObjectContext objectForKey:@"testObject"]).notTo.beIdenticalTo([contextHoldingObject2.ocsObjectContext objectForKey:@"testObject"]);

    // Context 3 derives from NCMIConfiguration
    NSObject *contextHoldingObject3 = [[NSObject alloc] init];
    [contextHoldingObject3 ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NCMIChildConfiguration class]];

    // Derived testObject should be fetched from its parent;
    // In the current system, the parent will be the last context bootstrapped, which can be variable at runtime
    expect([contextHoldingObject3.ocsObjectContext objectForKey:@"testObject"]).to.beIdenticalTo([contextHoldingObject2.ocsObjectContext objectForKey:@"testObject"]);
    expect([contextHoldingObject3.ocsObjectContext objectForKey:@"testObject"]).notTo.beIdenticalTo([contextHoldingObject1.ocsObjectContext objectForKey:@"testObject"]);
}

@end
