//
//  OCSDefinitionTest.m
//  Reliant
//
//  Created by Jens Goeman on 14/05/14.
//
//

#import <XCTest/XCTest.h>
#import "OCSDefinition.h"
#import "OCSSingletonScope.h"

@interface OCSDefinitionTest : XCTestCase {
    OCSDefinition *_definition;
}

@end

@implementation OCSDefinitionTest {
}

- (void)setUp
{
    [super setUp];
    _definition = [[OCSDefinition alloc] init];
    [_definition addAlias:@"Alias"];
    _definition.key = @"key";
    _definition.implementingClass = [NSString class];
    _definition.lazy = YES;
    _definition.scope = @"singleton";
}

- (void)testInitShouldCreateDefinition
{
    XCTAssertNotNil(_definition);
}

- (void)testShouldAddAlias{
    XCTAssertTrue([_definition.aliases indexOfObject:@"Alias"] != NSNotFound);
}

- (void)testAliasShouldBeFound {
    XCTAssertTrue([_definition isAlsoKnownWithAlias:@"Alias"]);
}

- (void)testKeyIsAsSet
{
    XCTAssertEqual(_definition.key,@"key");
}

- (void)testImplementingClassIsAsSet{
    XCTAssertEqual(_definition.implementingClass,[NSString class]);
}

- (void)testIsSingletonAsSet {
    XCTAssertTrue(_definition.singleton);
}

- (void)testIsLazyAsSet {
    XCTAssertTrue(_definition.lazy);
}

- (void)testScopeClassIsAsSet{
    XCTAssertEqual(_definition.scope, @"singleton");
}

@end
