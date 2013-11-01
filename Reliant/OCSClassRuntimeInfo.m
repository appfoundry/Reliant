//
// Created by Michael Seghers on 1/11/13.
//


#import "OCSClassRuntimeInfo.h"
#import "OCSPropertyRuntimeInfo.h"
#import <objc/objc-runtime.h>


@interface OCSClassRuntimeInfo () {
    NSMutableArray *_infos;
}

@end

@implementation OCSClassRuntimeInfo {

}

- (id)initWithClass:(Class)class
{
    self = [super init];
    if (self) {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        _infos = [NSMutableArray array];
        for (int i = 0; i < propertyCount; i++) {
            [_infos addObject:[[OCSPropertyRuntimeInfo alloc] initWithProperty:properties[i]]];
        }
        free(properties);
    }
    return self;
}

- (void) enumeratePropertiesWithBlock:(void(^)(OCSPropertyRuntimeInfo *)) block {
    for (OCSPropertyRuntimeInfo *info in _infos) {
        block(info);
    }
}

@end