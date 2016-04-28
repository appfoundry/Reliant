//
// Created by Michael Seghers on 24/08/14.
//

#import <UIKit/UIKit.h>
#import "OCSBoundContextLocatorOnViewControllerHierarchy.h"
#import "NSObject+OCSReliantContextBinding.h"
#import "OCSObjectContext.h"

@implementation OCSBoundContextLocatorOnViewControllerHierarchy

- (id <OCSObjectContext>)locateBoundContextForObject:(NSObject *)object {
    id<OCSObjectContext> context = nil;
    if ([object isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController *)object;
        UIViewController *parent = controller.parentViewController;
        context = parent.ocsObjectContext;
        if (!context) {
            context = [self locateBoundContextForObject:parent];
        }
    }
    return context;
}

@end