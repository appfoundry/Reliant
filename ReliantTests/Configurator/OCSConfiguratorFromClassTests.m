//
//  OCSConfiguratorFromClassTests.m
//  Reliant
//
//  Created by Michael Seghers on 17/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//



#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#if (TARGET_OS_IPHONE)
#import <UIKit/UIApplication.h>
#endif

#define LOG_RELIANT 1
#import "OCSConfiguratorFromClassTests.h"

#import "OCSConfiguratorFromClass.h"
#import "OCSObjectContext.h"
#import "DummyConfigurator.h"
#import "OCSSingletonScope.h"
#import "OCSDefinition.h"
#import "OCSObjectFactory.h"
#import "OCSScopeFactory.h"

@interface DummyConfigurator (SomeDummyCategory)

@end

@interface NameProvidingConfigurator : NSObject
@end

@implementation OCSConfiguratorFromClassTests {
    OCSConfiguratorFromClass *_configurator;
    OCSObjectContext *_context;
}

- (void) setUp {
    [super setUp];
    _configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[DummyConfigurator class]];
    _context = mock([OCSObjectContext class]);
    [_configurator.objectFactory bindToContext:_context];
}

- (void)testHasDefinitionForVerySmartName {
    assertThat(_configurator.objectKeys, hasItem(@"VerySmartName"));
    OCSDefinition *def = [_configurator definitionForKeyOrAlias:@"VerySmartName"];
    assertThat(def.key, is(equalTo(@"VerySmartName")));
    assertThat(def.scope, is(equalTo(@"singleton")));
    assertThat(def.aliases, hasItems(@"verySmartName", @"VERYSMARTNAME", @"aliasForVerySmartName", @"justAnotherNameForVerySmartName", nil));
}

- (void)testObjectFactoryIsGeneratedSubclassOfConfigurationClass {
    assertThat(_configurator.objectFactory, is(instanceOf([DummyConfigurator class])));
}

- (void)testObjectFactoryIsIndeedAnObjectFactory {
    NSObject *factory = (NSObject *)_configurator.objectFactory;
    assertThatBool([factory conformsToProtocol:@protocol(OCSObjectFactory)], is(equalToBool(YES)));
    assertThatBool([factory respondsToSelector:@selector(createObjectForDefinition:)], is(equalToBool(YES)));
    assertThatBool([factory respondsToSelector:@selector(bindToContext:)], is(equalToBool(YES)));
}


- (void)testObjectFactoryReturnsObjectFromCreateMethod {
    OCSDefinition *def = [_configurator definitionForKeyOrAlias:@"LazyOne"];
    id<OCSScopeFactory> factory = mockProtocol(@protocol(OCSScopeFactory));
    [given([_context scopeFactory]) willReturn:factory];
    id result = [_configurator.objectFactory createObjectForDefinition:def];
    assertThat(result, is(instanceOf([NSMutableDictionary class])));
}

- (void)testNestedPropertyIsTestedForOccuranceInContext {
    OCSDefinition *def = [_configurator definitionForKeyOrAlias:@"Super"];
    id result = [_configurator.objectFactory createObjectForDefinition:def];
    assertThat(result, is(notNilValue()));
    [verify(_context) objectForKey:@"VerySmartName"];
}

- (void)testContextNameIsDerivedFromFactoryClass {
    NSString *name = _configurator.contextName;
    assertThat(name, is(equalTo(@"DummyConfiguratorContext")));
}

- (void)testContextNameIsTakenFromFactoryClassWhenItProvidesContextNameMethod {
    _configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[NameProvidingConfigurator class]];
    assertThat(_configurator.contextName, is(equalTo(@"CustomContextName")));
}

@end


@implementation DummyConfigurator (SomeDummyCategory)

- (id) createEagerSingletonFromCategory {
    return @"FromCategory";
}

@end

@implementation NameProvidingConfigurator

- (NSString *) contextName {
    return @"CustomContextName";
}

@end

