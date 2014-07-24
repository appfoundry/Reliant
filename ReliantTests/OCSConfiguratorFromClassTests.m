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
#import "OCSApplicationContext+Protected.h"
#import "OCSSingletonScope.h"

@interface DummyConfigurator (SomeDummyCategory)

@end

@interface BadAliasFactoryClass : NSObject

@end

@interface AutoDetectedReliantConfiguration : NSObject

@end



@implementation OCSConfiguratorFromClassTests {
    OCSConfiguratorFromClass *configurator;

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
    configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[DummyConfigurator class]];
}

- (void) tearDown {
    // Tear-down code here.
    configurator = nil;

    [super tearDown];
}

- (void) testBeforeLoaded {
    OCSApplicationContext *context = mock([OCSApplicationContext class]);
    id object = [configurator objectForKey:@"VerySmartName" inContext:context];
    XCTAssertNil(object, @"No objects should ever be returned when still initializing");

}

- (id) doTestSingletonRetrievalWithKey:(NSString *) key andAliases:(NSArray *) aliases inContext:(OCSApplicationContext *) context {
    id singleton = [configurator objectForKey:key inContext:context];
    XCTAssertNotNil(singleton, @"Singleton %@ shoud be available", key);
    XCTAssertTrue(singleton == [configurator objectForKey:key inContext:context], @"Retrieving a singleton by key from the configurator should always return the same instance");
    [aliases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertTrue(singleton == [configurator objectForKey:obj inContext:context], @"Retrieving a singleton by alias from the configurator should always return the same instance");

    }];
    return singleton;
}


- (void) testLoadShouldInjectLoadedObjects {
    OCSApplicationContext *context = mock([OCSApplicationContext class]);
    [configurator contextLoaded:context];
    [verifyCount(context, times(6)) performInjectionOn:anything()];

    //TODO check which methods were called exactly, after refactoring the object storage to the context / scopes
}

- (void) testSameInstanceIsReturnedForKeyAndAliases {
    OCSApplicationContext *context = mock([OCSApplicationContext class]);
    [configurator contextLoaded:context];
    [self doTestSingletonRetrievalWithKey:@"Super" andAliases:@[@"super", @"SUPER"] inContext:context];
    [self doTestSingletonRetrievalWithKey:@"Extended" andAliases:@[@"extended", @"EXTENDED"] inContext:context];
}

- (void) testDifferentInjectedObjectsShouldHaveSameInstanceForSingleton {
    OCSApplicationContext *context = mock([OCSApplicationContext class]);
    [configurator contextLoaded:context];
    NSObject *verySmartItself = [configurator objectForKey:@"VerySmartName" inContext:context];
    ObjectWithInjectables *owi = [configurator objectForKey:@"Super" inContext:context];
    XCTAssertTrue(verySmartItself == owi.verySmartName, @"The constructor injected instance should be the same as the instance created by the base method");
}

- (void) testRetrievePrototypeObject {
    OCSApplicationContext *context = mock([OCSApplicationContext class]);
    [configurator contextLoaded:context];
    NSMutableArray *firstProto = [configurator objectForKey:@"UnbelievableOtherSmartName" inContext:context];
    XCTAssertNotNil(firstProto, @"Prototype should have been created");
    NSMutableArray *secondProto = [configurator objectForKey:@"UnbelievableOtherSmartName" inContext:context];
    XCTAssertNotNil(secondProto, @"Prototype should have been created");
    XCTAssertFalse(firstProto == secondProto, @"Prototype instances should be different");
}

- (void) testLazyLoading {
    OCSApplicationContext *context = mock([OCSApplicationContext class]);

    OCSSingletonScope *scope = [[OCSSingletonScope alloc] init];
    [given([context scopeForClass:anything()]) willReturn:scope];

    [configurator contextLoaded:context];
    NSDictionary *lazyObject = [configurator objectForKey:@"LazyOne" inContext:context];
    NSDictionary *newlyFetched = [configurator objectForKey:@"LazyOne" inContext:context];
    XCTAssertNotNil(lazyObject, @"lazyObject should not be nil");
    XCTAssertNotNil(newlyFetched, @"lazyObject should not be nil");
    XCTAssertTrue(lazyObject == newlyFetched, @"Instance should be the same when singleton");
    [verify(context) performInjectionOn:lazyObject];
}

#if (TARGET_OS_IPHONE)
- (void) testMemoryWarning {
    OCSApplicationContext *context = mock([OCSApplicationContext class]);
    [configurator contextLoaded:context];
    id firstNeverInjectedByOthers = [configurator objectForKey:@"NeverInjectedByOthers" inContext:context];

    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];

    id secondNeverInjectedByOthers = [self doTestSingletonRetrievalWithKey:@"NeverInjectedByOthers" andAliases:[NSArray arrayWithObjects:@"neverInjectedByOthers", @"NEVERINJECTEDBYOTHERS", nil] inContext:context];


    XCTAssertFalse(secondNeverInjectedByOthers == firstNeverInjectedByOthers, @"after memory warnings, objects should have been re-initialized");
    [verify(context) performInjectionOn:firstNeverInjectedByOthers];
    [verify(context) performInjectionOn:secondNeverInjectedByOthers];
}
#endif

- (void) testBadAliases {
    XCTAssertThrowsSpecificNamed([[OCSConfiguratorFromClass alloc] initWithClass:[BadAliasFactoryClass class]], NSException, @"OCSConfiguratorException", @"Should throw exception, aliases are bad");
}

- (void) testAutodetectConfiguration {
    OCSConfiguratorFromClass *autoDetectedConfig = [[OCSConfiguratorFromClass alloc] init];
    XCTAssertNotNil(autoDetectedConfig, @"Should init");
}


@end


@implementation DummyConfigurator (SomeDummyCategory)

- (id) createEagerSingletonFromCategory {
    return @"FromCategory";
}

@end

@implementation AutoDetectedReliantConfiguration

@end

@implementation BadAliasFactoryClass

- (id) createEagerSingleton {
    return @"Should be ignored, no key";
}

- (id) createEagerSingletonKeyValue {
    return @"KeyValue object";
}

- (NSArray *) aliasesForKeyValue {
    return [NSArray arrayWithObject:@"keyValue"];
}

@end
