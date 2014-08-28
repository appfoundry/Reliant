//
// Created by Michael Seghers on 24/08/14.
//

#import <UIKit/UIKit.h>
#import "OCSBoundContextLocatorOnViewControllerHierarchy.h"
#import "NSObject+OCSReliantContextBinding.h"
#import "OCSObjectContext.h"

@implementation OCSBoundContextLocatorOnViewControllerHierarchy {

}

- (id <OCSObjectContext>)locateBoundContextForObject:(NSObject *)object {
    UIViewController *controller = (UIViewController *)object;
    UIViewController *parent = controller.parentViewController;
    id<OCSObjectContext> context = nil;
    while (!context && parent) {
        context = parent.ocsObjectContext;
        parent = parent.parentViewController;
    }
    return context;
}

- (BOOL)canLocateBoundContextForObject:(NSObject *)object {
    return [object isKindOfClass:[UIViewController class]];
}


@end