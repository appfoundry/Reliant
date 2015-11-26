//
//  OCSObjectContextTests.m
//  Reliant
//
//  Created by Michael Seghers on 16/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//



#import <XCTest/XCTest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import <objc/runtime.h>

#define LOG_RELIANT 1

#import "OCSConfigurator.h"
#import "OCSObjectContext.h"
#import "OCSScopeFactory.h"
#import "OCSDefaultScopeFactory.h"
#import "OCSDefinition.h"
#import "OCSScope.h"
#import "OCSObjectFactory.h"

@protocol SomeSuperProtocol <NSObject>

@property(nonatomic, retain) NSString *superProtocolProperty;

@end

@interface DummyClass : NSObject <SomeSuperProtocol>

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

@interface SpiedObjectContext : OCSObjectContext

@property (nonatomic, strong) id injectedObject;

@end

@interface OCSObjectContextTests : XCTestCase

@end

@implementation OCSObjectContextTests {
    //SUT
    OCSObjectContext *_context;
    id<OCSConfigurator> _configurator;
    id<OCSScopeFactory> _scopeFactory;
    id<OCSObjectFactory> _objectFactory;
    id<OCSScope> _scope;
    NSMutableArray *_knownKeys;
}

- (void)setUp {
    [super setUp];
    _configurator = mockProtocol(@protocol(OCSConfigurator));
    [given(_configurator.contextName) willReturn:@"TestContext"];
    _objectFactory = mockProtocol(@protocol(OCSObjectFactory));
    _knownKeys = [[NSMutableArray alloc] init];
    [given([_configurator objectFactory]) willReturn:_objectFactory];
    [given([_configurator objectKeysAndAliases]) willReturn:_knownKeys];
    _scopeFactory = mockProtocol(@protocol(OCSScopeFactory));
    _scope = mockProtocol(@protocol(OCSScope));
    _context = [[OCSObjectContext alloc] initWithConfigurator:_configurator scopeFactory:_scopeFactory parentContext:nil];
}

- (void)testShouldNotInitWithoutConfig {
    _context = [[OCSObjectContext alloc] initWithConfigurator:nil scopeFactory:_scopeFactory parentContext:nil];
    assertThat(_context, is(nilValue()));
}

- (void)testShouldNotInitWithoutScopeFactory {
    _context = [[OCSObjectContext alloc] initWithConfigurator:_configurator scopeFactory:nil parentContext:nil];
    assertThat(_context, is(nilValue()));
}

- (void)testConvenienceInitFailsWhenNoReliantConfigurationClassFound {
    _context = [[OCSObjectContext alloc] init];
    assertThat(_context, is(nilValue()));
}

- (void)testConvenienceInitSucceedsWhenReliantConfigurationClassFound {
    Class reliantConfigurationClass = [self _createAutoDetectedReliantConfigurationClass];
    _context = [[OCSObjectContext alloc] init];
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
    _context = [[OCSObjectContext alloc] initWithConfigurator:_configurator];
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

- (void)testContextIsAskedToInjectObjectFactory {
    SpiedObjectContext *childContext = [[SpiedObjectContext alloc] initWithConfigurator:_configurator scopeFactory:_scopeFactory parentContext:nil];
    assertThat(childContext.injectedObject, is(sameInstance(_objectFactory)));
}

- (void)testContextGetsNameFromConfigurator {
    [given(_configurator.contextName) willReturn:@"ConfiguredName"];
    assertThat(_context.name, is(equalTo(@"ConfiguredName")));
}

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
@synthesize superProtocolProperty;

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

@implementation SpiedObjectContext

- (void)performInjectionOn:(id)object {
    [super performInjectionOn:object];
    self.injectedObject = object;
}

@end
