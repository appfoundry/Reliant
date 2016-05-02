//
// Created by Michael Seghers on 28/08/14.
//

#import "OCSBoundContextLocatorFactory.h"
#import "OCSBoundContextLocator.h"
#import "OCSBoundContextLocatorChain.h"
#import "OCSBoundContextLocatorOnGivenObject.h"
#import "OCSBoundContextLocatorOnSharedObject.h"
#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#import "OCSBoundContextLocatorOnViewControllerHierarchy.h"
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
#if TARGET_OS_IOS || TARGET_OS_TV
        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnViewControllerHierarchy alloc] init]];
        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnSharedObject alloc] initWithSharedObject:[UIApplication sharedApplication].delegate]];
#elif TARGET_OS_MAC && !TARGET_OS_WATCH
        [defaultLocator addBoundContextLocator:[[OCSBoundContextLocatorOnSharedObject alloc] initWithSharedObject:[NSApplication sharedApplication].delegate]];
#endif

        [self setContextLocator:defaultLocator];
    }
    return _contextLocator;
}

- (void)setContextLocator:(id <OCSBoundContextLocator>) contextLocator {
    _contextLocator = contextLocator;
}


@end