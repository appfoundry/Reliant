//
//  OCSConfiguratorFromClassTests.m
//  Reliant
//
//  Created by Michael Seghers on 17/05/12.
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

#if (TARGET_OS_IPHONE)
#import <UIKit/UIApplication.h>
#endif

#define LOG_RELIANT 1
#import "OCSConfiguratorFromClassTests.h"

#import "OCSConfiguratorFromClass.h"
#import "OCSApplicationContext.h"
#import "DummyConfigurator.h"
#import "OCSSingletonScope.h"
#import "OCSDefinition.h"
#import "OCSObjectFactory.h"
#import "OCSScopeFactory.h"

@interface DummyConfigurator (SomeDummyCategory)

@end

@interface BadAliasFactoryClass : NSObject

@end

/*@interface AutoDetectedReliantConfiguration : NSObject

@end*/



@implementation OCSConfiguratorFromClassTests {
    OCSConfiguratorFromClass *_configurator;
    OCSApplicationContext *_context;

    int verySmartNameInjected;
    int unbelievableOtherSmartNameInjected;
    int lazyOneInjected;
    int superInjected;
    int extendedInjected;
    int categoryInjected;
    int externalCategoryInjected;
}

- (void) setUp {
    [super setUp];
    _configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[DummyConfigurator class]];
    _context = mock([OCSApplicationContext class]);
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
    (result, is(instanceOf([NSMutableDictionary class])));
}

- (void)testNestedPropertyIsTestedForOccuranceInContext {
    OCSDefinition *def = [_configurator definitionForKeyOrAlias:@"Super"];
    id result = [_configurator.objectFactory createObjectForDefinition:def];
    assertThat(result, is(notNilValue()));
    [verify(_context) objectForKey:@"VerySmartName"];
}

@end


@implementation DummyConfigurator (SomeDummyCategory)

- (id) createEagerSingletonFromCategory {
    return @"FromCategory";
}

@end

