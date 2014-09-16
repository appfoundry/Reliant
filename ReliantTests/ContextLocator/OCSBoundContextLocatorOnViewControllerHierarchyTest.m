//
//  OCSBoundContextLocatorOnViewControllerHierarchyTest.m
//  Reliant
//
//  Created by Michael Seghers on 24/08/14.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "OCSBoundContextLocatorOnViewControllerHierarchy.h"
#import "NSObject+OCSReliantContextBinding.h"

@interface OCSBoundContextLocatorOnViewControllerHierarchyTest : XCTestCase

@end

@implementation OCSBoundContextLocatorOnViewControllerHierarchyTest {
    OCSBoundContextLocatorOnViewControllerHierarchy *_locator;
}

- (void)setUp {
    [super setUp];
    _locator = [[OCSBoundContextLocatorOnViewControllerHierarchy alloc] init];
}


- (void)testFindsContextOnAnyParentButNotSelf {
    UIViewController *grandDad = [[UIViewController alloc] init];
    UIViewController *dad = [[UIViewController alloc] init];
    UIViewController *son = [[UIViewController alloc] init];

    [grandDad addChildViewController:dad];
    [dad addChildViewController:son];

    id <OCSObjectContext> context = mockProtocol(@protocol(OCSObjectContext));
    son.ocsObjectContext = mockProtocol(@protocol(OCSObjectContext));
    grandDad.ocsObjectContext = context;
    
    assertThat([_locator locateBoundContextForObject:son], is(sameInstance(context)));
}

- (void)testReturnsNilForNonViewController {
    NSObject *object = [[NSObject alloc] init];
    assertThat([_locator locateBoundContextForObject:object], is(nilValue()));
}

@end
