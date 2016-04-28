//
// Created by Michael Seghers on 28/08/14.
//

#import "OCSBoundContextLocatorFactory.h"
#import "OCSBoundContextLocator.h"
#import "OCSBoundContextLocatorChain.h"
#import "OCSBoundContextLocatorOnGivenObject.h"
#if TARGET_OS_IOS
#import "OCSBoundContextLocatorOnViewControllerHierarchy.h"
#import "OCSBoundContextLocatorOnApplicationDelegate.h"
#elif TARGET_OS_MAC
#import "OCSBoundContextLocatorOnOSXApplicationDelegate.h"
#endif

@interface OCSBoundContextLocatorFactory () {
    id <OCSBoundContextLocator> _contextLocator;
}
@end

@implementation OCSBoundContextLocatorFactory

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

        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnGivenObject alloc] init]];
#if TARGET_OS_IOS
        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnViewControllerHierarchy alloc] init]];
        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnApplicationDelegate alloc] init]];
#elif TARGET_OS_MAC
        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnOSXApplicationDelegate alloc] init]];
#endif

        [self setContextLocator:defaultLocator];
    }
    return _contextLocator;
}

- (void)setContextLocator:(id <OCSBoundContextLocator>) contextLocator {
    _contextLocator = contextLocator;
}


@end