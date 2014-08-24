//
// Created by Michael Seghers on 24/08/14.
//

#import <UIKit/UIKit.h>
#import "OCSBoundContextLocatorOnApplicationDelegate.h"
#import "NSObject+OCSReliantContextBinding.h"
#import "OCSObjectContext.h"


@implementation OCSBoundContextLocatorOnApplicationDelegate {

}

- (id <OCSObjectContext>)locateBoundContextForObject:(NSObject *)object {
    NSObject<UIApplicationDelegate> *delegate = [UIApplication sharedApplication].delegate;
    return delegate.ocsObjectContext;
}

- (BOOL)canLocateBoundContextForObject:(NSObject *)object {
    return YES;
}

@end