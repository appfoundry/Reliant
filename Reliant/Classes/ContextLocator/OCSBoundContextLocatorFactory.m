//
// Created by Michael Seghers on 28/08/14.
//

#import "OCSBoundContextLocatorFactory.h"
#import "OCSBoundContextLocator.h"
#import "OCSBoundContextLocatorChain.h"
#import "OCSBoundContextLocatorOnSelf.h"
#if TARGET_OS_IPHONE
#import "OCSBoundContextLocatorOnViewControllerHierarchy.h"
#import "OCSBoundContextLocatorOnApplicationDelegate.h"
#else
#import "OCSBoundContextLocatorOnOSXApplicationDelegate.h"
#endif


@implementation OCSBoundContextLocatorFactory {

}

+ (instancetype)sharedBoundContextLocatorFactory {
    static OCSBoundContextLocatorFactory *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OCSBoundContextLocatorFactory alloc] init];
    });
    return sharedInstance;
}

- (id <OCSBoundContextLocator>)contextLocator {
    if (!_contextLocator) {
        OCSBoundContextLocatorChain *defaultLocator = [[OCSBoundContextLocatorChain alloc] init];

        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnSelf alloc] init]];
#if TARGET_OS_IPHONE
        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnViewControllerHierarchy alloc] init]];
        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnApplicationDelegate alloc] init]];
#else
        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnOSXApplicationDelegate alloc] init]];
#endif

        _contextLocator = defaultLocator;
    }
    return _contextLocator;
}


@end