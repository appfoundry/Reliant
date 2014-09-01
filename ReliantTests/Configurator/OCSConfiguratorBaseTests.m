//
//  OCSConfiguratorBaseTests.m
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "OCSConfiguratorBase.h"
#import "OCSConfiguratorBase+ForSubclassEyesOnly.h"
#import "OCSDefinition.h"


@interface OCSConfiguratorBaseTests : XCTestCase

@end

@implementation OCSConfiguratorBaseTests {
    OCSConfiguratorBase *_configurator;
}

- (void) setUp {
    [super setUp];
    _configurator = [[OCSConfiguratorBase alloc] init];
    OCSDefinition *def = [[OCSDefinition alloc] init];
    def.key = @"SomeKey";
    [def addAlias:@"AliasOne"];
    [def addAlias:@"AliasTwo"];
    def.scope = @"dummy";
    [_configurator registerDefinition:def];
}

- (void)testConfiguratorObjectKeysReturnsOnlyKeysOfDefinitions {
    NSArray *array = _configurator.objectKeys;
    assertThat(array, allOf(hasCountOf(1), hasItems(@"SomeKey", nil), nil));
}

- (void)testConfiguratorObjectKeysAndAliasReturnsKeysAndAliasesOfDefinitions {
    NSArray *array = _configurator.objectKeysAndAliases;
    assertThat(array, allOf(hasCountOf(3), hasItems(@"SomeKey", @"AliasOne", @"AliasTwo", nil), nil));
}

- (void)testRegisteringAKeyAnAlreadyExistingKeyThrowsAnException {
    OCSDefinition *def = [[OCSDefinition alloc] init];
    def.key = @"SomeKey";
    XCTAssertThrows([_configurator registerDefinition:def]);
}

- (void)testRegisteringAKeyForAnAlreadyExistingAliasThrowsAnException {
    OCSDefinition *def = [[OCSDefinition alloc] init];
    def.key = @"AliasOne";
    XCTAssertThrows([_configurator registerDefinition:def]);
}

- (void)testRegisteringAnAliasForAnAlreadyExistingKeyThrowsAnException {
    OCSDefinition *def = [[OCSDefinition alloc] init];
    def.key = @"NewKey";
    [def addAlias:@"SomeKey"];
    XCTAssertThrows([_configurator registerDefinition:def]);
}

- (void)testRegisteringAnAliasForAnAlreadyExistingAliasThrowsAnException {
    OCSDefinition *def = [[OCSDefinition alloc] init];
    def.key = @"NewKey";
    [def addAlias:@"AliasOne"];
    XCTAssertThrows([_configurator registerDefinition:def]);
}

- (void)testDefinitionForKeyOrAliasReturnsDefinitionWhenKeyIsFound {
    OCSDefinition *definition = [_configurator definitionForKeyOrAlias:@"SomeKey"];
    assertThat(definition, is(notNilValue()));
}

- (void)testDefinitionForKeyOrAliasReturnsDefinitionWhenAliasIsFound {
    OCSDefinition *definition = [_configurator definitionForKeyOrAlias:@"AliasOne"];
    assertThat(definition, is(notNilValue()));
}

- (void)testDefinitionForKeyOrAliasReturnsNilWhenNotFound {
    OCSDefinition *definition = [_configurator definitionForKeyOrAlias:@"NonExistingKeyOrAlias"];
    assertThat(definition, is(nilValue()));
}

- (void)testContextNameShouldReturnNil {
    NSString *result = _configurator.contextName;
    assertThat(result, is(nilValue()));
}

@end
