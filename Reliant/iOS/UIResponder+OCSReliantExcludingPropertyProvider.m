//
//  UIResponder+OCSReliantExcludingPropertyProvider.m
//  Reliant
//
//  Created by Michael Seghers on 27/10/13.
//
//

#import "UIResponder+OCSReliantExcludingPropertyProvider.h"
#import "NSObject+OCSReliantExcludingPropertyProvider.h"

@implementation UIResponder (OCSReliantExcludingPropertyProvider)

+ (BOOL) OCS_reliantShouldIgnorePropertyWithName:(NSString *) name {
    static NSArray *excludedProps;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        excludedProps = @[@"restorationIdentifier"];
    });
    return [super OCS_reliantShouldIgnorePropertyWithName:name] || [excludedProps containsObject:name];
}

@end
