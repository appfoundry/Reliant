//
//  OCSConfiguratorFromClassTests.m
//  Reliant
//
//  Created by Michael Seghers on 17/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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


#import <OCMock/OCMock.h>

#import "OCSConfiguratorFromClassTests.h"

#import "OCSConfiguratorFromClass.h"
#import "OCSApplicationContext.h"

@interface DummyConfigurator (SomeDummyCategory)

@end

@interface ObjectWithInjectables : NSObject

@property (nonatomic, retain) id verySmartName;

- (id) initWithVerySmartName:(id) verySmartName;

@end

@interface ExtendedObjectWithInjectables : ObjectWithInjectables

@property (nonatomic, retain) id unbelievableOtherSmartName;

@end

@interface BadAliasFactoryClass : NSObject

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
    
    // Set-up code here.
    verySmartNameInjected = 0;
    unbelievableOtherSmartNameInjected = 0;
    lazyOneInjected = 0;
    superInjected = 0;
    extendedInjected = 0;
    categoryInjected = 0;
    externalCategoryInjected = 0;
    
    configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[DummyConfigurator class]];
}

- (void) tearDown {
    // Tear-down code here.
    configurator = nil;
    
    [super tearDown];
}

- (void) testBeforeLoaded {
    id context = [OCMockObject mockForClass:[OCSApplicationContext class]];
    
    id object = [configurator objectForKey:@"VerySmartName" inContext:context];
    STAssertNil(object, @"No objects should ever be returned when still initializing");
    
}

- (void) doTestSingletonRetrievalWithKey:(NSString *) key andAliases:(NSArray *) aliases inContext:(OCSApplicationContext *) context {
    id singleton = [configurator objectForKey:key inContext:context];
    STAssertNotNil(singleton, @"Singleton %@ shoud be available", key);
    STAssertTrue(singleton == [configurator objectForKey:key inContext:context], @"Retrieving a singleton by key from the configurator should always return the same instance");
    [aliases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        STAssertTrue(singleton == [configurator objectForKey:obj inContext:context], @"Retrieving a singleton by alias from the configurator should always return the same instance");
        
    }];
}

- (void) testAfterLoaded {
    id context = [OCMockObject mockForClass:[OCSApplicationContext class]];
    
    //5 eager singletons to be loaded (3 from main class, 2 from category" -> 5 injection attempts
    //Remaining object is not a singleton or is lazy loaded and should not have been loaded, nor injected after a contetLoaded
    for (int i = 0; i < 5; i++) {
        [[context expect] performInjectionOn:[OCMArg checkWithSelector:@selector(checkInjection:) onObject:self]];
    }
    
    [configurator contextLoaded:context];
    
    STAssertEquals(verySmartNameInjected, 1, @"Very smart object should have been injected by now");
    STAssertEquals(superInjected, 1, @"Super object should have been injected by now");
    STAssertEquals(extendedInjected, 1, @"Extended object should have been injected by now");
    STAssertEquals(categoryInjected, 1, @"Category object should have been injected by now");
    STAssertEquals(externalCategoryInjected, 1, @"External Category object should have been injected by now");
    STAssertEquals(unbelievableOtherSmartNameInjected, 0, @"Ubelievable object should not have been injected yet");
    STAssertEquals(lazyOneInjected, 0, @"Lazy object should not have been injected yet");
    
    //Now fetching the singletons, with aliases should work, they should not be re-injected
    
    [self doTestSingletonRetrievalWithKey:@"VerySmartName" andAliases:[NSArray arrayWithObjects:@"verySmartName", @"VERYSMARTNAME", @"aliasForVerySmartName", @"justAnotherNameForVerySmartName", nil] inContext:context];
    [self doTestSingletonRetrievalWithKey:@"Super" andAliases:[NSArray arrayWithObjects:@"super", @"SUPER", nil] inContext:context];
    [self doTestSingletonRetrievalWithKey:@"Extended" andAliases:[NSArray arrayWithObjects:@"extended", @"EXTENDED", nil] inContext:context];
    
    [[context expect] performInjectionOn:[OCMArg checkWithSelector:@selector(checkInjection:) onObject:self]];
    
    id unbelievableObject = [configurator objectForKey:@"UnbelievableOtherSmartName" inContext:context];
    
    STAssertNotNil(unbelievableObject, @"Unbelievable object shoud be available");
    
    STAssertEquals(verySmartNameInjected, 1, @"Very smart object should have been injected by now");
    STAssertEquals(superInjected, 1, @"Super object should have been injected by now");
    STAssertEquals(extendedInjected, 1, @"Extended object should have been injected by now");
    STAssertEquals(categoryInjected, 1, @"Category object should have been injected by now");
    STAssertEquals(externalCategoryInjected, 1, @"External Category object should have been injected by now");
    STAssertEquals(unbelievableOtherSmartNameInjected, 1, @"Ubelievable object should not have been injected by now");
    STAssertEquals(lazyOneInjected, 0, @"Lazy object should not have been injected yet");
    
    //Re-fetch a new instance object, it should always be a new instance which has been injected.
    [[context expect] performInjectionOn:[OCMArg checkWithSelector:@selector(checkInjection:) onObject:self]];
    
    
    id otherUnbelievableObject = [configurator objectForKey:@"UnbelievableOtherSmartName" inContext:context];
    STAssertFalse(unbelievableObject == otherUnbelievableObject, @"New instance objects should always be different instances");
    STAssertEquals(verySmartNameInjected, 1, @"Very smart object should have been injected by now");
    STAssertEquals(superInjected, 1, @"Super object should have been injected by now");
    STAssertEquals(extendedInjected, 1, @"Extended object should have been injected by now");
    STAssertEquals(categoryInjected, 1, @"Category object should have been injected by now");
    STAssertEquals(externalCategoryInjected, 1, @"External Category object should have been injected by now");
    STAssertEquals(unbelievableOtherSmartNameInjected, 2, @"Ubelievable object should not have been injected again");
    STAssertEquals(lazyOneInjected, 0, @"Lazy object should not have been injected yet");
    
    [[context expect] performInjectionOn:[OCMArg checkWithSelector:@selector(checkInjection:) onObject:self]];
    id lazyObject = [configurator objectForKey:@"LazyOne" inContext:context];
    STAssertNotNil(lazyObject, @"lazyObject should not be nil");
    STAssertEquals(lazyOneInjected, 1, @"Lazy object should have been injected now");
    
    //We also know by now that the "wrong" configurator methods did not yield an object...
    
    [context verify];
    
}

- (void) testBadAliases {
    STAssertThrowsSpecificNamed([[OCSConfiguratorFromClass alloc] initWithClass:[BadAliasFactoryClass class]], NSException, @"OCSConfiguratorException", @"Should throw exception, aliases are bad");
    
    
}

- (BOOL) checkInjection:(id<NSObject>) injectedObject {
    BOOL result = YES;
    
    if ([injectedObject isMemberOfClass:[NSObject class]]) {
        verySmartNameInjected++;
    } else if ([injectedObject isKindOfClass:[NSArray class]]) {
        unbelievableOtherSmartNameInjected++;
    } else if ([injectedObject isKindOfClass:[NSDictionary class]]) {
        lazyOneInjected++;
    } else if ([injectedObject isMemberOfClass:[ObjectWithInjectables class]]) {
        superInjected++;
    } else if ([injectedObject isMemberOfClass:[ExtendedObjectWithInjectables class]]) {
        extendedInjected++;
    } else if ([injectedObject isKindOfClass:[NSString class]]) {
        NSString *value = (NSString *) injectedObject;
        if ([@"FromCategory" isEqualToString:value]) {
            categoryInjected++;
        } else if ([@"ExternalCategory" isEqualToString:value]) {
            externalCategoryInjected++;
        }
    } else {
        result = NO;
    }
                                          
    return result;
}


@end

@implementation DummyConfigurator 

- (id) createEagerSingletonVerySmartName {
    return [[[NSObject alloc] init] autorelease];
}

- (NSArray *) aliasesForVerySmartName {
    return [NSArray arrayWithObjects:@"aliasForVerySmartName", @"justAnotherNameForVerySmartName", nil];
}

- (id) createPrototypeUnbelievableOtherSmartName {
    return [[[NSMutableArray alloc] init] autorelease];
}

- (id) createSingletonLazyOne {
    return [[[NSMutableDictionary alloc] init] autorelease];
}

- (ObjectWithInjectables *) createEagerSingletonSuper {
    return [[[ObjectWithInjectables alloc] initWithVerySmartName:[self createEagerSingletonVerySmartName]] autorelease];
}

- (ExtendedObjectWithInjectables *) createEagerSingletonExtended {
    return [[[ExtendedObjectWithInjectables alloc] init] autorelease];
}

- (id) createWithBadName {
    return @"WRONG";
}


- (id) createSingletonSomeObjectWithSuper:(ObjectWithInjectables *) super andExtended:(ExtendedObjectWithInjectables *) extended {
    return @"WRONG AGAIN";
}

- (id) createPrototypeWithParameter:(id) param {
    return @"WRONG AGAIN AGAIN";
}


@end

@implementation DummyConfigurator (SomeDummyCategory)

- (id) createEagerSingletonFromCategory {
    return @"FromCategory";
}

@end

@implementation ObjectWithInjectables

@synthesize verySmartName;

- (id) initWithVerySmartName:(id)averySmartName {
    self = [super init];
    if (self) {
        verySmartName = averySmartName;
    }
    return self;
}

@end


@implementation ExtendedObjectWithInjectables

@synthesize unbelievableOtherSmartName;

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
