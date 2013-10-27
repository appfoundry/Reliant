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

#import "OCSApplicationContextTests.h"

#import "OCSConfigurator.h"
#import "OCSApplicationContext.h"

@protocol SomeSuperProtocol <NSObject>

@property (nonatomic, retain) NSString *superProtocolProperty;

@end

@interface DummyClass : NSObject<SomeSuperProtocol> {
    @private
    NSString *publiclyKnownPrivate;
}

@property (nonatomic, strong) NSString *publiclyKnownPrivate;
@property (nonatomic, strong) NSString *publiclyKnownProperty;
@property (nonatomic, readonly) NSString *readOnlyProperty;
@property (nonatomic, assign) BOOL boolProperty;
@property (nonatomic, assign) char charProperty;
@property (nonatomic, assign) int intProperty;
@property (nonatomic, assign) float floatProperty;
@property (nonatomic, assign) double doubleProperty;
@property (nonatomic, assign) long longProperty;

@end

@interface DummyClass () 

@property (nonatomic, strong) NSString *privateProperty;
@property (nonatomic, strong) id privatePropertyWithCustomVarName;
@property (nonatomic, strong) id unknownProperty;

@end

@protocol SomeProtocol <NSObject>

@property (nonatomic, retain) NSString *prototypeProperty;

@optional
@property (nonatomic, retain) NSString *optionalProperty;

@end

@interface ExtendedDummyClass : DummyClass<SomeProtocol>

@property (nonatomic, strong) NSString *extendedProperty;

@end

@interface EmptyClass : NSObject

@end



@implementation OCSApplicationContextTests {
    //SUT
    OCSApplicationContext *context;
    id configurator;
}

- (void) setUp {
    [super setUp];
    // Set-up code here.
    configurator = mockProtocol(@protocol(OCSConfigurator));
    context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];
}

- (void) tearDown {
    // Tear-down code here.
    
    configurator = nil;
    context = nil;
    
    [super tearDown];
}

- (void) testStart {
    BOOL result = [context start];
    STAssertTrue(result, @"Application context startup is expected to succeed");
    [verify(configurator) contextLoaded:context];
}

- (void) testObjectForKey {
    [given([configurator objectForKey:@"SomeKey" inContext:context]) willReturn:@"StringObject"];
    
    STAssertTrue([@"StringObject" isEqualToString:[context objectForKey:@"SomeKey"]], @"SomeKey key should return the configurator's StringObject");
    STAssertNil([context objectForKey:@"UnknownKey"], @"UnknownKey should return nil");
}

- (void) testPerformInjection {
    DummyClass *dummy = [[DummyClass alloc] init];
    
    [given([configurator objectForKey:@"publiclyKnownPrivate" inContext:context]) willReturn:@"PRKP"];
    [given([configurator objectForKey:@"publiclyKnownProperty" inContext:context]) willReturn:@"PUKP"];
    [given([configurator objectForKey:@"privateProperty" inContext:context]) willReturn:@"PP"];
    [given([configurator objectForKey:@"privatePropertyWithCustomVarName" inContext:context]) willReturn:@"PPCN"];
    [given([configurator objectForKey:@"superProtocolProperty" inContext:context]) willReturn:@"SPP"];

    [context performInjectionOn:dummy];
    
    STAssertTrue([@"PRKP" isEqualToString:[dummy valueForKey:@"publiclyKnownPrivate"]], @"publiclyKnownPrivate should be set to PRKP");
    STAssertTrue([@"PUKP" isEqualToString:[dummy valueForKey:@"publiclyKnownProperty"]], @"publiclyKnownProperty should be set to PUKP");
    STAssertTrue([@"PP" isEqualToString:[dummy valueForKey:@"privateProperty"]], @"privateProperty should be set to PP");
    STAssertTrue([@"PPCN" isEqualToString:[dummy valueForKey:@"privatePropertyWithCustomVarName"]], @"privatePropertyWithCustomVarName should be set to PPCN");
    STAssertTrue([@"SPP" isEqualToString:[dummy valueForKey:@"superProtocolProperty"]], @"superProrocolProperty should be set to SPP");
    STAssertNil(dummy.unknownProperty, @"unknownProperty should be nil");
}

- (void) testPerformInjectionOnExtendedObject {
    ExtendedDummyClass *dummy = [[ExtendedDummyClass alloc] init];
    
    [given([configurator objectForKey:@"publiclyKnownPrivate" inContext:context]) willReturn:@"PRKP"];
    [given([configurator objectForKey:@"publiclyKnownProperty" inContext:context]) willReturn:@"PUKP"];
    [given([configurator objectForKey:@"privateProperty" inContext:context]) willReturn:@"PP"];
    [given([configurator objectForKey:@"privatePropertyWithCustomVarName" inContext:context]) willReturn:@"PPCN"];
    [given([configurator objectForKey:@"superProtocolProperty" inContext:context]) willReturn:@"SPP"];
    [given([configurator objectForKey:@"privateProperty" inContext:context]) willReturn:@"PrivP"];
    [given([configurator objectForKey:@"extendedProperty" inContext:context]) willReturn:@"EP"];
    [given([configurator objectForKey:@"prototypeProperty" inContext:context]) willReturn:@"PrP"];

    [context performInjectionOn:dummy];
    
    STAssertTrue([@"PRKP" isEqualToString:[dummy valueForKey:@"publiclyKnownPrivate"]], @"publiclyKnownPrivate should be set to PRKP");
    STAssertTrue([@"PUKP" isEqualToString:[dummy valueForKey:@"publiclyKnownProperty"]], @"publiclyKnownProperty should be set to PUKP");
    STAssertTrue([@"PrivP" isEqualToString:[dummy valueForKey:@"privateProperty"]], @"privateProperty should be set to PP");
    STAssertTrue([@"PPCN" isEqualToString:[dummy valueForKey:@"privatePropertyWithCustomVarName"]], @"privatePropertyWithCustomVarName should be set to PPCN");
    STAssertTrue([@"EP" isEqualToString:[dummy valueForKey:@"extendedProperty"]], @"extendedProperty should be set to EP");
    STAssertTrue([@"SPP" isEqualToString:[dummy valueForKey:@"superProtocolProperty"]], @"superProrocolProperty should be set to SPP");
    STAssertTrue([@"PrP" isEqualToString:[dummy valueForKey:@"prototypeProperty"]], @"prototypeProperty should be set to PrP");
    STAssertNil(dummy.unknownProperty, @"unknownProperty should be nil");
}

- (void) testPerformInjectionOnEmptyClass {
    //We must be able to try to inject classes that on their own have no dependencies. No actual injection should happen. The configurator should never be called.
    EmptyClass *dummy = [[EmptyClass alloc] init];
    [context performInjectionOn:dummy];
    [verifyCount(configurator, times(0)) objectForKey:anything() inContext:anything()];
}

- (void) testPerformInjectionOnAlreadyInjectedClass {
    //We must be able to try to inject classes that on their own have no dependencies. No actual injection should happen. The configurator should never be called.
    DummyClass *dummy = [[DummyClass alloc] init];
    dummy.publiclyKnownProperty = @"AlreadyThere";
    
    [given([configurator objectForKey:@"publiclyKnownPrivate" inContext:context]) willReturn:@"PRKP"];
    [given([configurator objectForKey:@"publiclyKnownProperty" inContext:context]) willReturn:@"PUKP"];
    [given([configurator objectForKey:@"privateProperty" inContext:context]) willReturn:@"PP"];
    [given([configurator objectForKey:@"privatePropertyWithCustomVarName" inContext:context]) willReturn:@"PPCN"];
    [given([configurator objectForKey:@"superProtocolProperty" inContext:context]) willReturn:@"SPP"];

    [context performInjectionOn:dummy];
    
    STAssertTrue([@"PRKP" isEqualToString:[dummy valueForKey:@"publiclyKnownPrivate"]], @"publiclyKnownPrivate should be set to PRKP");
    STAssertTrue([@"AlreadyThere" isEqualToString:[dummy valueForKey:@"publiclyKnownProperty"]], @"publiclyKnownProperty should not have been overriden!");
    STAssertTrue([@"PP" isEqualToString:[dummy valueForKey:@"privateProperty"]], @"privateProperty should be set to PP");
    STAssertTrue([@"PPCN" isEqualToString:[dummy valueForKey:@"privatePropertyWithCustomVarName"]], @"privatePropertyWithCustomVarName should be set to PPCN");
    STAssertTrue([@"SPP" isEqualToString:[dummy valueForKey:@"superProtocolProperty"]], @"superProrocolProperty should be set to SPP");
    STAssertNil(dummy.unknownProperty, @"unknownProperty should be nil");
}

@end

@implementation DummyClass

@synthesize publiclyKnownPrivate;
@synthesize publiclyKnownProperty;
@synthesize privateProperty;
@synthesize privatePropertyWithCustomVarName = _customVarName;
@synthesize unknownProperty;
@synthesize superProtocolProperty;
@synthesize intProperty, boolProperty, longProperty, charProperty, floatProperty, doubleProperty, readOnlyProperty;

@end

@implementation ExtendedDummyClass

@synthesize extendedProperty;
@synthesize prototypeProperty;

@end

@implementation EmptyClass

@end
