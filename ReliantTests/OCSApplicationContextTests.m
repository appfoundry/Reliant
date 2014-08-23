//
//  OCSApplicationContextTests.m
//  Reliant
//
//  Created by Michael Seghers on 16/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


#define MOCKITO_SHORTHAND

#import <OCMockito/OCMockito.h>

#define HC_SHORTHAND

#import <OCHamcrest/OCHamcrest.h>
#import <objc/runtime.h>

#import "OCSApplicationContextTests.h"

#define LOG_RELIANT 1

#import "OCSConfigurator.h"
#import "OCSApplicationContext.h"
#import "OCSScopeFactory.h"
#import "OCSDefaultScopeFactory.h"
#import "OCSDefinition.h"
#import "OCSScope.h"
#import "OCSObjectFactory.h"

@protocol SomeSuperProtocol <NSObject>

@property(nonatomic, retain) NSString *superProtocolProperty;

@end

@interface DummyClass : NSObject <SomeSuperProtocol> {
@private
    NSString *publiclyKnownPrivate;
}

@property(nonatomic, strong) NSString *publiclyKnownPrivate;
@property(nonatomic, strong) NSString *publiclyKnownProperty;
@property(nonatomic, readonly) NSString *readOnlyProperty;
@property(nonatomic, assign) BOOL boolProperty;
@property(nonatomic, assign) char charProperty;
@property(nonatomic, assign) int intProperty;
@property(nonatomic, assign) float floatProperty;
@property(nonatomic, assign) double doubleProperty;
@property(nonatomic, assign) long longProperty;

@end

@protocol OptionalPropertyProtocol <NSObject>

@optional
@property(nonatomic, strong) NSString *optional;

@end

@interface ProtocolAdoptingWithoutImplementingOptionalPropertyClass : NSObject <OptionalPropertyProtocol>

@end

@interface ProtocolAdoptingAndImplementingOptionalPropertyClass : NSObject <OptionalPropertyProtocol>

@end

@interface DummyClass ()

@property(nonatomic, strong) NSString *privateProperty;
@property(nonatomic, strong) id privatePropertyWithCustomVarName;
@property(nonatomic, strong) id unknownProperty;

@end

@protocol SomeProtocol <NSObject>

@property(nonatomic, retain) NSString *prototypeProperty;

@optional
@property(nonatomic, retain) NSString *optionalProperty;

@end

@interface ExtendedDummyClass : DummyClass <SomeProtocol>

@property(nonatomic, strong) NSString *extendedProperty;

@end

@interface EmptyClass : NSObject

@end

@implementation OCSApplicationContextTests {
    //SUT
    OCSApplicationContext *_context;
    id<OCSConfigurator> _configurator;
    id<OCSScopeFactory> _scopeFactory;
    id<OCSObjectFactory> _objectFactory;
    id<OCSScope> _scope;
    NSMutableArray *_knownKeys;
}

- (void)setUp {
    [super setUp];
    _configurator = mockProtocol(@protocol(OCSConfigurator));
    _objectFactory = mockProtocol(@protocol(OCSObjectFactory));
    _knownKeys = [[NSMutableArray alloc] init];
    [given([_configurator objectFactory]) willReturn:_objectFactory];
    [given([_configurator objectKeys]) willReturn:_knownKeys];
    _scopeFactory = mockProtocol(@protocol(OCSScopeFactory));
    _scope = mockProtocol(@protocol(OCSScope));
    _context = [[OCSApplicationContext alloc] initWithConfigurator:_configurator scopeFactory:_scopeFactory];
}

- (void)testShouldNotInitWithoutConfig {
    _context = [[OCSApplicationContext alloc] initWithConfigurator:nil scopeFactory:_scopeFactory];
    assertThat(_context, is(nilValue()));
}

- (void)testShouldNotInitWithoutScopeFactory {
    _context = [[OCSApplicationContext alloc] initWithConfigurator:_configurator scopeFactory:nil];
    assertThat(_context, is(nilValue()));
}

- (void)testConvenienceInitFailsWhenNoReliantConfigurationClassFound {
    _context = [[OCSApplicationContext alloc] init];
    assertThat(_context, is(nilValue()));
}

- (void)testConvenienceInitSucceedsWhenReliantConfigurationClassFound {
    Class reliantConfigurationClass = [self _createAutoDetectedReliantConfigurationClass];
    _context = [[OCSApplicationContext alloc] init];
    assertThat(_context, is(notNilValue()));
    objc_disposeClassPair(NSClassFromString(@"OCSReliantExtended_DummyTestReliantConfiguration"));
    objc_disposeClassPair(reliantConfigurationClass);

}

- (Class)_createAutoDetectedReliantConfigurationClass {
    Class reliantConfigurationClass = objc_allocateClassPair([NSObject class], "DummyTestReliantConfiguration", sizeof(id));
    objc_registerClassPair(reliantConfigurationClass);
    return reliantConfigurationClass;
}

- (void)testConvenienceInitWithConfiguratorCreatesSetsScopeFactoryToDefaultImplementation {
    _context = [[OCSApplicationContext alloc] initWithConfigurator:_configurator];
    assertThat(_context.scopeFactory, is(instanceOf([OCSDefaultScopeFactory class])));
}


- (void)testStart {
    BOOL result = [_context start];
    XCTAssertTrue(result, @"Application context startup is expected to succeed");
}

- (void)testObjectForKeyReturnsObjectFromScopeIfAvailable {
    NSString *objectKey = @"SomeKey";
    id expectedObject = @"StringObject";

    [self _prepareContextToFindObjectForKey:objectKey inScopeNamed:@"scope" withValue:expectedObject];

    id result = [_context objectForKey:objectKey];
    assertThat(result, is(equalTo(expectedObject)));
}

- (void)testObjectForKeyReturnsNilIfKeyNotFoundInDefinition {
    assertThat([_context objectForKey:@"UnknownKey"], is(nilValue()));
}

- (void)testObjectForKeyDoesNotAskForScopeWhenDefinitionIsMissing {
    [_context objectForKey:@"UnknownKey"];
    [verifyCount(_scopeFactory, never()) scopeForName:anything()];
}

- (void) testObjectForKeyShouldCallObjectFactoryWhenScopeIsMissingValue {
    NSString *objectKey = @"SomeKey";
    NSString *scopeName = @"scope";
    id expectedObject = @"StringObject";

    OCSDefinition *def = [self _prepareContextToNotFindObjectForKey:objectKey inScopeNamed:scopeName expectedObject:expectedObject];

    [_context objectForKey:objectKey];
    [verify(_objectFactory) createObjectForDefinition:def];
}

- (void)testObjectForKeyShouldStoreObjectFactoryCreatedValueInScopeWhenScopeIsMissingValue {
    NSString *objectKey = @"SomeKey";
    NSString *scopeName = @"scope";
    id expectedObject = @"StringObject";

    [self _prepareContextToNotFindObjectForKey:objectKey inScopeNamed:scopeName expectedObject:expectedObject];

    [_context objectForKey:objectKey];
    [verify(_scope) registerObject:expectedObject forKey:objectKey];
}

- (void)testObjectForKeyShouldReturnObjectFactoryCreatedValueInScopeWhenScopeIsMissingValue {
    NSString *objectKey = @"SomeKey";
    NSString *scopeName = @"scope";
    id expectedObject = @"StringObject";
    [self _prepareContextToNotFindObjectForKey:objectKey inScopeNamed:scopeName expectedObject:expectedObject];
    assertThat([_context objectForKey:objectKey], is(equalTo(expectedObject)));
}

- (void)testInjectionShouldHaveHappenedWhenObjectIsNewlyCreated {
    NSString *objectKey = @"SomeKey";
    NSString *scopeName = @"scope";
    id expectedObject = [[DummyClass alloc] init];
    [self _prepareContextToNotFindObjectForKey:objectKey inScopeNamed:scopeName expectedObject:expectedObject];
    [self _prepareContextToFindObjectForKey:@"publiclyKnownProperty" inScopeNamed:@"scope" withValue:@"InjectedString"];
    DummyClass *result = [_context objectForKey:objectKey];
    assertThat(result.publiclyKnownProperty, is(@"InjectedString"));
}

- (void)testShouldBindContext {
    [verify(_objectFactory) bindToContext:_context];
}


/*
- (void)testPerformInjection {
    DummyClass *dummy = [[DummyClass alloc] init];

    [given([configurator objectForKey:@"publiclyKnownPrivate" inContext:context]) willReturn:@"PRKP"];
    [given([configurator objectForKey:@"publiclyKnownProperty" inContext:context]) willReturn:@"PUKP"];
    [given([configurator objectForKey:@"privateProperty" inContext:context]) willReturn:@"PP"];
    [given([configurator objectForKey:@"privatePropertyWithCustomVarName" inContext:context]) willReturn:@"PPCN"];
    [given([configurator objectForKey:@"superProtocolProperty" inContext:context]) willReturn:@"SPP"];
    [given([configurator objectKeys]) willReturn:@[@"publiclyKnownPrivate", @"publiclyKnownProperty", @"privateProperty", @"privatePropertyWithCustomVarName", @"superProtocolProperty"]];

    [context performInjectionOn:dummy];

    XCTAssertTrue([@"PRKP" isEqualToString:[dummy valueForKey:@"publiclyKnownPrivate"]], @"publiclyKnownPrivate should be set to PRKP");
    XCTAssertTrue([@"PUKP" isEqualToString:[dummy valueForKey:@"publiclyKnownProperty"]], @"publiclyKnownProperty should be set to PUKP");
    XCTAssertTrue([@"PP" isEqualToString:[dummy valueForKey:@"privateProperty"]], @"privateProperty should be set to PP");
    XCTAssertTrue([@"PPCN" isEqualToString:[dummy valueForKey:@"privatePropertyWithCustomVarName"]], @"privatePropertyWithCustomVarName should be set to PPCN");
    XCTAssertTrue([@"SPP" isEqualToString:[dummy valueForKey:@"superProtocolProperty"]], @"superProrocolProperty should be set to SPP");
    XCTAssertNil(dummy.unknownProperty, @"unknownProperty should be nil");
}

- (void)testPerformInjectionOnExtendedObject {
    ExtendedDummyClass *dummy = [[ExtendedDummyClass alloc] init];

    [given([configurator objectForKey:@"publiclyKnownPrivate" inContext:context]) willReturn:@"PRKP"];
    [given([configurator objectForKey:@"publiclyKnownProperty" inContext:context]) willReturn:@"PUKP"];
    [given([configurator objectForKey:@"privateProperty" inContext:context]) willReturn:@"PP"];
    [given([configurator objectForKey:@"privatePropertyWithCustomVarName" inContext:context]) willReturn:@"PPCN"];
    [given([configurator objectForKey:@"superProtocolProperty" inContext:context]) willReturn:@"SPP"];
    [given([configurator objectForKey:@"privateProperty" inContext:context]) willReturn:@"PrivP"];
    [given([configurator objectForKey:@"extendedProperty" inContext:context]) willReturn:@"EP"];
    [given([configurator objectForKey:@"prototypeProperty" inContext:context]) willReturn:@"PrP"];
    [given([configurator objectKeys]) willReturn:@[@"publiclyKnownPrivate", @"publiclyKnownProperty", @"privateProperty", @"privatePropertyWithCustomVarName", @"superProtocolProperty", @"privateProperty", @"extendedProperty", @"prototypeProperty"]];

    [context performInjectionOn:dummy];

    XCTAssertTrue([@"PRKP" isEqualToString:[dummy valueForKey:@"publiclyKnownPrivate"]], @"publiclyKnownPrivate should be set to PRKP");
    XCTAssertTrue([@"PUKP" isEqualToString:[dummy valueForKey:@"publiclyKnownProperty"]], @"publiclyKnownProperty should be set to PUKP");
    XCTAssertTrue([@"PrivP" isEqualToString:[dummy valueForKey:@"privateProperty"]], @"privateProperty should be set to PP");
    XCTAssertTrue([@"PPCN" isEqualToString:[dummy valueForKey:@"privatePropertyWithCustomVarName"]], @"privatePropertyWithCustomVarName should be set to PPCN");
    XCTAssertTrue([@"EP" isEqualToString:[dummy valueForKey:@"extendedProperty"]], @"extendedProperty should be set to EP");
    XCTAssertTrue([@"SPP" isEqualToString:[dummy valueForKey:@"superProtocolProperty"]], @"superProrocolProperty should be set to SPP");
    XCTAssertTrue([@"PrP" isEqualToString:[dummy valueForKey:@"prototypeProperty"]], @"prototypeProperty should be set to PrP");
    XCTAssertNil(dummy.unknownProperty, @"unknownProperty should be nil");
}

- (void)testPerformInjectionOnEmptyClass {
    //We must be able to try to inject classes that on their own have no dependencies. No actual injection should happen. The configurator should never be called.
    EmptyClass *dummy = [[EmptyClass alloc] init];
    [context performInjectionOn:dummy];
    [verifyCount(configurator, times(0)) objectForKey:(id) anything() inContext:anything()];
}

- (void)testPerformInjectionOnAlreadyInjectedClass {
    //We must be able to try to inject classes that on their own have no dependencies. No actual injection should happen. The configurator should never be called.
    DummyClass *dummy = [[DummyClass alloc] init];
    dummy.publiclyKnownProperty = @"AlreadyThere";

    [given([configurator objectForKey:@"publiclyKnownPrivate" inContext:context]) willReturn:@"PRKP"];
    [given([configurator objectForKey:@"publiclyKnownProperty" inContext:context]) willReturn:@"PUKP"];
    [given([configurator objectForKey:@"privateProperty" inContext:context]) willReturn:@"PP"];
    [given([configurator objectForKey:@"privatePropertyWithCustomVarName" inContext:context]) willReturn:@"PPCN"];
    [given([configurator objectForKey:@"superProtocolProperty" inContext:context]) willReturn:@"SPP"];
    [given([configurator objectKeys]) willReturn:@[@"publiclyKnownPrivate", @"publiclyKnownProperty", @"privateProperty", @"privatePropertyWithCustomVarName", @"superProtocolProperty"]];

    [context performInjectionOn:dummy];

    XCTAssertTrue([@"PRKP" isEqualToString:[dummy valueForKey:@"publiclyKnownPrivate"]], @"publiclyKnownPrivate should be set to PRKP");
    XCTAssertTrue([@"AlreadyThere" isEqualToString:[dummy valueForKey:@"publiclyKnownProperty"]], @"publiclyKnownProperty should not have been overriden!");
    XCTAssertTrue([@"PP" isEqualToString:[dummy valueForKey:@"privateProperty"]], @"privateProperty should be set to PP");
    XCTAssertTrue([@"PPCN" isEqualToString:[dummy valueForKey:@"privatePropertyWithCustomVarName"]], @"privatePropertyWithCustomVarName should be set to PPCN");
    XCTAssertTrue([@"SPP" isEqualToString:[dummy valueForKey:@"superProtocolProperty"]], @"superProrocolProperty should be set to SPP");
    XCTAssertNil(dummy.unknownProperty, @"unknownProperty should be nil");
}

- (void)testLoadContextDefault {
    OCSApplicationContext *autoContext = [[OCSApplicationContext alloc] init];
    XCTAssertNotNil(autoContext, @"Context should have initialized with the auto configured configuration");
}

- (void)testInitContextWithoutConfigShouldReturnNull {
    OCSApplicationContext *nilContext = [[OCSApplicationContext alloc] initWithConfigurator:nil];
    XCTAssertNil(nilContext, @"Context should not have initialized with the auto configured configuration");
}

- (void)testPerformInjectionOnOptionalProperty {
    ProtocolAdoptingWithoutImplementingOptionalPropertyClass *dummy = [[ProtocolAdoptingWithoutImplementingOptionalPropertyClass alloc] init];

    [given([configurator objectForKey:@"optional" inContext:context]) willReturn:@"PRKP"];
    [given([configurator objectKeys]) willReturn:@[@"optional"]];

    XCTAssertNoThrow([context performInjectionOn:dummy], @"This expression should not throw an exception");
}

- (void)testPerformInjectionOnOptionalImplementedProperty {
    ProtocolAdoptingAndImplementingOptionalPropertyClass *dummy = [[ProtocolAdoptingAndImplementingOptionalPropertyClass alloc] init];

    [given([configurator objectForKey:@"optional" inContext:context]) willReturn:@"PRKP"];
    [given([configurator objectKeys]) willReturn:@[@"optional"]];

    [context performInjectionOn:dummy];

    XCTAssertEqual(@"PRKP", dummy.optional, @"Optional was not set by reliant");
}

- (void)testScopeForClassShouldCreateNewScopeIfScopeNotAvailable {
    id <OCSScope> foundScope = [context scopeForClass:[DummyScope class]];
    XCTAssertNotNil(foundScope);
}

- (void)testScopeForClassShouldReturnScopeOfSpecifiedType {
    id <OCSScope> foundScope = [context scopeForClass:[DummyScope class]];
    XCTAssertEqual([foundScope class], [DummyScope class]);
}

- (void)testScopeForClassShouldReturnAvailableScopeIfAlreadyCreated {
    id <OCSScope> foundScope = [context scopeForClass:[DummyScope class]];
    id <OCSScope> secondFoundScope = [context scopeForClass:[DummyScope class]];
    XCTAssertTrue(foundScope == secondFoundScope);
}

- (void)testScopeOfClassShouldThrowExceptionWhenPassingNonOCSScopeClass {
    XCTAssertThrowsSpecificNamed([context scopeForClass:[NSString class]], NSException, @"OCSInvalidScopeException");
}
   */

- (OCSDefinition *)_prepareContextToFindObjectForKey:(NSString *)objectKey inScopeNamed:(NSString *)scopeName withValue:(id)expectedObject {
    OCSDefinition *def = [[OCSDefinition alloc] init];
    def.key = objectKey;
    def.scope = scopeName;
    [given([_configurator definitionForKeyOrAlias:objectKey]) willReturn:def];
    [given([_scopeFactory scopeForName:scopeName]) willReturn:_scope];
    [given([_scope objectForKey:objectKey]) willReturn:expectedObject];

    [_knownKeys addObject:objectKey];
    return def;
}

- (OCSDefinition *)_prepareContextToNotFindObjectForKey:(NSString *)objectKey inScopeNamed:(NSString *)scopeName expectedObject:(id)expectedObject {
    OCSDefinition *def = [self _prepareContextToFindObjectForKey:objectKey inScopeNamed:scopeName withValue:nil];
    [given([_objectFactory createObjectForDefinition:def]) willReturn:expectedObject];
    return def;
}


@end

@implementation DummyClass

@synthesize privatePropertyWithCustomVarName = _customVarName;

@end

@implementation ProtocolAdoptingAndImplementingOptionalPropertyClass

@synthesize optional;

@end

@implementation ProtocolAdoptingWithoutImplementingOptionalPropertyClass

@end

@implementation ExtendedDummyClass

@synthesize extendedProperty;
@synthesize prototypeProperty;

@end

@implementation EmptyClass

@end
