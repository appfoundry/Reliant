//
//  OCSBoundContextLocatorOnSharedObjectTests.m
//  Reliant
//
//  Created by Michael Seghers on 02/05/16.
//
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "NSObject+OCSReliantContextBinding.h"
#import "OCSBoundContextLocatorOnSharedObject.h"
#import "OCSObjectContext.h"

@interface FakeSharedObject : NSObject

+(instancetype)sharedFakeSharedObject;

@end

@interface OCSBoundContextLocatorOnSharedObjectTests : XCTestCase {
    id <OCSObjectContext> _objectContext;
    OCSBoundContextLocatorOnSharedObject *_locator;
}

@end

@implementation OCSBoundContextLocatorOnSharedObjectTests

- (void)setUp {
    [super setUp];
    _objectContext = mockProtocol(@protocol(OCSObjectContext));
    [FakeSharedObject sharedFakeSharedObject].ocsObjectContext = _objectContext;
    _locator = [[OCSBoundContextLocatorOnSharedObject alloc] initWithSharedObject:[FakeSharedObject sharedFakeSharedObject]];
}

- (void)testLocatorReturnContextOnSharedObject {
    id <OCSObjectContext> context = [_locator locateBoundContextForObject:self];
    assertThat(context, is(sameInstance(_objectContext)));
}

@end


@implementation FakeSharedObject

+(instancetype)sharedFakeSharedObject {
    static FakeSharedObject *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end