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

+ (NSArray *)OCS_propertiesReliantShouldIgnore {
    static NSArray *excludedProps;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        excludedProps = [[super OCS_propertiesReliantShouldIgnore] arrayByAddingObjectsFromArray:@[@"tabBarItem", @"title", @"toolbarItems", @"view"]];
    });
    return excludedProps;
}

@end

