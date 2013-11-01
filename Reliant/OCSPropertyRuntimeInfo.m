//
// Created by Michael Seghers on 1/11/13.
//


#import "OCSPropertyRuntimeInfo.h"


@implementation OCSPropertyRuntimeInfo {

}

- (id)initWithProperty:(objc_property_t)property
{
    self = [super init];
    if (self) {
        NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        NSArray *components = [propertyAttributes componentsSeparatedByString:@","];
        _name = [NSString stringWithUTF8String:property_getName(property)];
        _objectType = [[components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self MATCHES %@", @"T.*"]] lastObject];
        _readOnly = [components containsObject:@"R"];
        _isObject = [_objectType characterAtIndex:1] == '@';
        _customGetter = [[[components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self MATCHES %@", @"G.*"]] lastObject] substringFromIndex:1];
        _customSetter = [[[components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self MATCHES %@", @"S.*"]] lastObject] substringFromIndex:1];
    }
    return self;
}

@end