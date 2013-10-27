//
//  NSObject+OCSReliantExcludingPropertyProvider.m
//  Reliant
//
//  Created by Michael Seghers on 27/10/13.
//
//

#import "NSObject+OCSReliantExcludingPropertyProvider.h"

@implementation NSObject (OCSReliantExcludingPropertiesProvider)

+ (NSArray *)OCS_propertiesReliantShouldIgnore {
    static NSArray *excludedProps;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        excludedProps = @[@"accessibilityPath", @"accessibilityLabel", @"accessibilityHint", @"accessibilityValue", @"accessibilityLanguage"];
    });
    return excludedProps;
}

@end
