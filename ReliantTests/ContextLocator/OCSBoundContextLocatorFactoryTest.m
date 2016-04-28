//
//  OCSBoundContextLocatorFactoryTest.m
//  Reliant
//
//  Created by Michael Seghers on 28/08/14.
//
//

#import <XCTest/XCTest.h>
#import "OCSBoundContextLocatorFactory.h"
#import "OCSBoundContextLocatorChain.h"
#import "OCSBoundContextLocatorOnGivenObject.h"
#if TARGET_OS_IPHONE
#import "OCSBoundContextLocatorOnViewControllerHierarchy.h"
#import "OCSBoundContextLocatorOnApplicationDelegate.h"
#else
#import "OCSBoundContextLocatorOnOSXApplicationDelegate.h"
#endif

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>


@interface OCSBoundContextLocatorFactoryTest : XCTestCase

@end

@implementation OCSBoundContextLocatorFactoryTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)testShouldCreateChainLocatorByDefault {
    OCSBoundContextLocatorFactory *factory = [OCSBoundContextLocatorFactory sharedBoundContextLocatorFactory];
    id <OCSBoundContextLocator> locator = factory.contextLocator;
    assertThat(locator, is(instanceOf([OCSBoundContextLocatorChain class])));
}

- (void)testDefaultLocatorHasNecessaryLoctorsInChain {
    OCSBoundContextLocatorChain *chain =  [OCSBoundContextLocatorFactory sharedBoundContextLocatorFactory].contextLocator;
#if TARGET_OS_IOS
    assertThat(chain.locators, hasCountOf(3));
    assertThat(chain.locators, hasItems(instanceOf([OCSBoundContextLocatorOnGivenObject class]), instanceOf([OCSBoundContextLocatorOnViewControllerHierarchy class]), instanceOf([OCSBoundContextLocatorOnApplicationDelegate class]), nil));
#elif TARGET_OS_MAC
    assertThat(chain.locators, hasCountOf(2));
    assertThat(chain.locators, hasItems(instanceOf([OCSBoundContextLocatorOnGivenObject class]), instanceOf([OCSBoundContextLocatorOnOSXApplicationDelegate class]), nil));
#else
    assertThat(chain.locators, hasCountOf(1));
    assertThat(chain.locators, hasItems(instanceOf([OCSBoundContextLocatorOnGivenObject class]), nil));
#endif
}

@end
