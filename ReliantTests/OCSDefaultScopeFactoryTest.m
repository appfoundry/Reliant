//
//  OCSDefaultScopeFactoryTest.m
//  Reliant
//
//  Created by Michael Seghers on 22/08/14.
//
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "OCSDefaultScopeFactory.h"
#import "OCSSingletonScope.h"
#import "OCSPrototypeScope.h"

@interface OCSDefaultScopeFactoryTest : XCTestCase

@end

@implementation OCSDefaultScopeFactoryTest {
    OCSDefaultScopeFactory*_factory;
}

- (void)setUp {
    [super setUp];
    _factory = [[OCSDefaultScopeFactory alloc] init];
}

- (void)testScopeForSingletonIsOCSSingletonScope {
    assertThat([_factory scopeForName:@"singleton"], is(instanceOf([OCSSingletonScope class])));
}

- (void)testScopeForPrototypeIsOCSPrototypeScope {
    ([_factory scopeForName:@"prototype"], is(instanceOf([OCSPrototypeScope class])));
}

- (void)testScopeForWhateverIsOCSSingletonScope {
    ([_factory scopeForName:@"whatever"], is(instanceOf([OCSSingletonScope class])));
}

- (void)testScopeForNilIsNil {
    ([_factory scopeForName:nil], is(nilValue()));
}

@end
