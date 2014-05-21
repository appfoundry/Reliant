//
//  OCSConfiguratorBaseTests.m
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "OCSApplicationContext.h"
#import "OCSConfiguratorBase.h"
#import "OCSConfiguratorBase+ForSubclassEyesOnly.h"
#import "OCSDefinition.h"
#import "OCSSingletonScope.h"
#import "DummyScope.h"
#import "OCSApplicationContext+Protected.h"

#import "OCSConfiguratorBaseTests.h"

@interface DummyBaseConfiguratorExtension : OCSConfiguratorBase

@property(nonatomic) BOOL internalInitCalled;
@property(nonatomic, strong) NSDictionary *objectRegistry;

@end

@implementation DummyBaseConfiguratorExtension

- (id)init
{
    self = [super init];
    if (self) {
        OCSDefinition *def = [[OCSDefinition alloc] init];
        def.key = @"SomeKey";
        def.scopeClass = [DummyScope class];
        [self registerDefinition:def];
    }
    return self;
}

- (id) createObjectInstanceForKey:(NSString *)key inContext:(OCSApplicationContext *)context {
    return self.objectRegistry[key];
}
- (void) internalContextLoaded:(OCSApplicationContext *) context {
    self.internalInitCalled = YES;
}

@end

@interface SimpleObjectHolder : NSObject

@property (nonatomic, strong) id object;

@end

@interface BadDummyBaseConfiguratorExtension : OCSConfiguratorBase

@end

@implementation BadDummyBaseConfiguratorExtension

@end

@interface OCSConfiguratorBase (TestAdditions)

- (void) addDefinition:(OCSDefinition *) def;

@end

@implementation OCSConfiguratorBase (TestAdditions)

- (void) addDefinition:(OCSDefinition *) def  {
    [self registerDefinition:def];
}

@end



@implementation OCSConfiguratorBaseTests {
    DummyBaseConfiguratorExtension *dummyConfigurator;
    BadDummyBaseConfiguratorExtension *badDummyConfigurator;
    OCSApplicationContext *context;
}

- (void) setUp {
    [super setUp];
    dummyConfigurator = [[DummyBaseConfiguratorExtension alloc] init];
    badDummyConfigurator = [[BadDummyBaseConfiguratorExtension alloc] init];
    context = mock([OCSApplicationContext class]);
}

- (void) tearDown {
    dummyConfigurator = nil;
    context = nil;
    [super tearDown];
}

- (void) testObjectForKeyBeforeLoaded {
    id result = [dummyConfigurator objectForKey:@"object" inContext:context];
    XCTAssertNil(result, @"Result should always be nil before the context has been marked as loaded");
}

- (void) testObjectForKeyAfterLoaded {
    OCSDefinition *def = [[OCSDefinition alloc] init];
    def.key = @"object";
    def.scopeClass = [DummyScope class];
    [dummyConfigurator registerDefinition:def];
    
    dummyConfigurator.initializing = NO;
    SimpleObjectHolder *holder = [[SimpleObjectHolder alloc] init];
    [dummyConfigurator setObjectRegistry:@{@"SomeKey" : holder, @"object" : @"injected"}];
    id result = [dummyConfigurator objectForKey:@"SomeKey" inContext:context];
    XCTAssertEqualObjects(result, holder, @"The result of the internal function should have been returned");
    [verify(context) performInjectionOn:holder];
}


- (void) testContextLoadedBadSubclass {
    XCTAssertThrowsSpecificNamed([badDummyConfigurator contextLoaded:context], NSException, @"OCSConfiguratorException", @"OCSConfiguratorException expected when directly calling this (abstract)");
}

- (void) testContextLoadedWithGoodSubclass {
    XCTAssertTrue([dummyConfigurator initializing], @"Initializing flag should be true by default.");
    [dummyConfigurator contextLoaded:context];
    XCTAssertFalse([dummyConfigurator initializing], @"Initializing flag should have been switched off.");
    XCTAssertTrue([dummyConfigurator internalInitCalled], @"Internal init should have been called.");
}

- (void) addDefinitions:(OCSConfiguratorBase *) configurator {
    OCSDefinition *lazy = [[OCSDefinition alloc] init];
    lazy.scopeClass = [OCSSingletonScope class];
    lazy.lazy = YES;
    lazy.key = @"LazySingletonKey";
    
    [configurator addDefinition:lazy];
    
    OCSDefinition *eager = [[OCSDefinition alloc] init];
    eager.scopeClass = [OCSSingletonScope class];
    eager.lazy = NO;
    eager.key = @"EagerSingletonKey";
    
    [configurator addDefinition:eager];
    
    OCSDefinition *prototype = [[OCSDefinition alloc] init];
    prototype.key = @"PrototypeKey";
    
    [configurator addDefinition:prototype];
}

- (void) testContextLoadedBadSubclassHavingDefinitions {
    [self addDefinitions:badDummyConfigurator];
    
    XCTAssertThrowsSpecificNamed([badDummyConfigurator contextLoaded:context], NSException, @"OCSConfiguratorException", @"OCSConfiguratorException expected when directly calling this (abstract)");
}

- (void) testContextLoadedWithGoodSubclassHavingDefinitions {
    [self addDefinitions:dummyConfigurator];

    NSObject *fakeObject = [[NSObject alloc] init];
    [dummyConfigurator setObjectRegistry:@{@"EagerSingletonKey" : fakeObject}];
    XCTAssertTrue([dummyConfigurator initializing], @"Initializing flag should be true by default.");
    [dummyConfigurator contextLoaded:context];
    XCTAssertFalse([dummyConfigurator initializing], @"Initializing flag should have been switched off.");
    XCTAssertTrue([dummyConfigurator internalInitCalled], @"Internal init should have been called.");
    [verify(context) performInjectionOn:fakeObject];
}

- (void)testConfiguratorReturnKnownKeysAndAliases {
    OCSDefinition *def = [[OCSDefinition alloc] init];
    def.key = @"OtherKey";
    [def addAlias:@"alias1"];
    [def addAlias:@"alias2"];
    [dummyConfigurator registerDefinition:def];
    NSArray *objectKeys = [dummyConfigurator objectKeys];
    NSArray *expected = @[@"SomeKey",@"OtherKey",@"alias1",@"alias2"];

    XCTAssertTrue([objectKeys isEqualToArray:expected], @"The expected objects keys %@ were returned as %@",expected.description,objectKeys.description);
}

- (void)testObjectForKeyInContextShouldGetTheObjectFromTheScopeFoundInApplicationContext {
    OCSDefinition *definition = [[OCSDefinition alloc] init];
    definition.key = @"theKey";
    definition.scopeClass = [DummyScope class];
    [dummyConfigurator registerDefinition:definition];
    dummyConfigurator.initializing = NO;
    [dummyConfigurator objectForKey:@"theKey" inContext:context];
    [verify(context) scopeForClass:[DummyScope class]];


}

@end

@implementation SimpleObjectHolder

@end
