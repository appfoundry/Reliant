//
//  UIViewController+OCSReliantExcludingPropertyProvider.m
//  Reliant
//
//  Created by Michael Seghers on 27/10/13.
//
//

#import "UIViewController+OCSReliantExcludingPropertyProvider.h"
#import "NSObject+OCSReliantExcludingPropertyProvider.h"

@implementation UIViewController (OCSReliantExcludingPropertyProvider)

+ (BOOL)ocsReliantShouldIgnorePropertyWithName:(NSString *) name {
    static NSArray *excludedProps;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        excludedProps = @[@"tabBarItem", @"title", @"toolbarItems", @"view", @"aggregateStatisticsDisplayCountKey", @"nibName", @"storyboard", @"parentViewController", @"modalTransitionView", @"mutableChildViewControllers", @"childModalViewController", @"parentModalViewController", @"searchDisplayController", @"dropShadowView", @"afterAppearanceBlock", @"transitioningDelegate", @"customTransitioningView"];
    });
    return [name hasPrefix:@"_"] || [super ocsReliantShouldIgnorePropertyWithName:name] || [excludedProps containsObject:name];
}

@end

