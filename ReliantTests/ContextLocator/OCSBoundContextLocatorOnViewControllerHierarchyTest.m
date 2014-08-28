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


- (void)testAppliesForViewControllers {
    UIViewController *controller = [[UIViewController alloc] init];
    assertThatBool([_locator canLocateBoundContextForObject:controller], is(equalToBool(YES)));
}

- (void)testDoesNotApplyForNonViewController {
    assertThatBool([_locator canLocateBoundContextForObject:self], is(equalToBool(NO)));
}

- (void)testFindsContextOnHighestParent {
    UIViewController *grandDad = [[UIViewController alloc] init];
    UIViewController *dad = [[UIViewController alloc] init];
    UIViewController *son = [[UIViewController alloc] init];

    [grandDad addChildViewController:dad];
    [dad addChildViewController:son];

    id <OCSObjectContext> context = mockProtocol(@protocol(OCSObjectContext));
    grandDad.ocsObjectContext = context;
    
    assertThat([_locator locateBoundContextForObject:son], is(sameInstance(context)));
}

- (void)testOnlyFindsContextOnParents {
    UIViewController *grandDad = [[UIViewController alloc] init];
    UIViewController *dad = [[UIViewController alloc] init];
    UIViewController *son = [[UIViewController alloc] init];

    [grandDad addChildViewController:dad];
    [dad addChildViewController:son];

    id <OCSObjectContext> context = mockProtocol(@protocol(OCSObjectContext));
    son.ocsObjectContext = context;

    assertThat([_locator locateBoundContextForObject:son], is(nilValue()));
}

@end
