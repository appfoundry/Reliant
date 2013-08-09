//
//  OCSConfiguratorBaseTests.m
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//

#import <OCMock/OCMock.h>

#import "OCSApplicationContext.h"
#import "OCSConfiguratorBase.h"
#import "OCSConfiguratorBase+ForSubclassEyesOnly.h"
#import "OCSDefinition.h"

#import "OCSConfiguratorBaseTests.h"

@interface DummyBaseConfiguratorExtension : OCSConfiguratorBase

@end

@implementation DummyBaseConfiguratorExtension

- (id)init
{
    self = [super init];
    if (self) {
        OCSDefinition *def = [[OCSDefinition alloc] init];
        def.key = @"SomeKey";
        [self registerDefinition:def];
        [def release];
    }
    return self;
}

- (id) createObjectInstanceForKey:(NSString *)key inContext:(OCSApplicationContext *)context {
    return nil;
}
- (void) internalContextLoaded:(OCSApplicationContext *) context {
    NSLog(@"internal context loaded called");
}

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
    id dummyConfigurator;
    id badDummyConfigurator;
    id context;
}

- (void) setUp {
    [super setUp];

    dummyConfigurator = [OCMockObject partialMockForObject:[[[DummyBaseConfiguratorExtension alloc] init] autorelease]];
    badDummyConfigurator = [OCMockObject partialMockForObject:[[[BadDummyBaseConfiguratorExtension alloc] init] autorelease]];
    context = [OCMockObject mockForClass:[OCSApplicationContext class]];
}

- (void) tearDown {
    dummyConfigurator = nil;
    context = nil;
    [super tearDown];
}

- (void) testObjectForKeyBeforeLoaded {
    id result = [dummyConfigurator objectForKey:@"SomeKey" inContext:context];
    
    STAssertNil(result, @"Result should always be nil before the context has been marked as loaded");
}

- (void) testObjectForKeyAfterLoaded {
    BOOL noo = NO;
    [[[dummyConfigurator stub] andReturnValue:OCMOCK_VALUE(noo)] initializing];
    [[[dummyConfigurator expect] andReturn:@"ReturnedObject"] createObjectInstanceForKey:@"SomeKey" inContext:context];
    [[context expect] performInjectionOn:@"ReturnedObject"];
    
    id result = [dummyConfigurator objectForKey:@"SomeKey" inContext:context];
    
    [dummyConfigurator verify];
    
    STAssertEqualObjects(result, @"ReturnedObject", @"The result of the internal function should have been returned");
}


- (void) testContextLoadedBadSubclass {
    STAssertThrowsSpecificNamed([badDummyConfigurator contextLoaded:context], NSException, @"OCSConfiguratorException", @"OCSConfiguratorException expected when directly calling this (abstract)");
}

- (void) testContextLoadedWithGoodSubclass {
    [[dummyConfigurator expect] internalContextLoaded:context];
    
    STAssertTrue([dummyConfigurator initializing], @"Initializing flag should be true by default.");
    
    [dummyConfigurator contextLoaded:context];
    
    STAssertFalse([dummyConfigurator initializing], @"Initializing flag should have been switched off.");
    
    [dummyConfigurator verify];
}

- (void) addDefinitions:(OCSConfiguratorBase *) configurator {
    OCSDefinition *lazy = [[[OCSDefinition alloc] init] autorelease];
    lazy.singleton = YES;
    lazy.lazy = YES;
    lazy.key = @"LazySingletonKey";
    
    [configurator addDefinition:lazy];
    
    OCSDefinition *eager = [[[OCSDefinition alloc] init] autorelease];
    eager.singleton = YES;
    eager.lazy = NO;
    eager.key = @"EagerSingletonKey";
    
    [configurator addDefinition:eager];
    
    OCSDefinition *prototype = [[[OCSDefinition alloc] init] autorelease];
    prototype.singleton = NO;
    prototype.key = @"PrototypeKey";
    
    [configurator addDefinition:prototype];
}

- (void) testContextLoadedBadSubclassHavingDefinitions {
    [self addDefinitions:badDummyConfigurator];
    
    STAssertThrowsSpecificNamed([badDummyConfigurator contextLoaded:context], NSException, @"OCSConfiguratorException", @"OCSConfiguratorException expected when directly calling this (abstract)");
}

- (void) testContextLoadedWithGoodSubclassHavingDefinitions {
    [self addDefinitions:dummyConfigurator];

    NSObject *fakeObject = [[NSObject alloc] init];
    [[[dummyConfigurator expect] andReturn:fakeObject] createObjectInstanceForKey:@"EagerSingletonKey" inContext:context];
    
    
    [[dummyConfigurator expect] internalContextLoaded:context];
    
    [[context expect] performInjectionOn:fakeObject];
    
    STAssertTrue([dummyConfigurator initializing], @"Initializing flag should be true by default.");
    
    [dummyConfigurator contextLoaded:context];
    
    STAssertFalse([dummyConfigurator initializing], @"Initializing flag should have been switched off.");
    
    [dummyConfigurator verify];
    [context verify];
}







@end
