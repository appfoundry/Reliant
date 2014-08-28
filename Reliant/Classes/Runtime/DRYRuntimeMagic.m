//
// Created by Michael Seghers on 23/08/14.
//

#import <objc/runtime.h>
#import "DRYRuntimeMagic.h"
#import "OCSPropertyRuntimeInfo.h"


@implementation DRYRuntimeMagic {

}

+ (void)copyPropertyNamed:(NSString *)name fromClass:(Class)origin toClass:(Class)destination {
    objc_property_t factoryCallStackProperty = class_getProperty(origin, [name cStringUsingEncoding:NSUTF8StringEncoding]);
    unsigned int attributeCount = 0;
    objc_property_attribute_t *propertyAttributeList = property_copyAttributeList(factoryCallStackProperty, &attributeCount);
    class_addProperty(destination, property_getName(factoryCallStackProperty), propertyAttributeList, attributeCount);
    free(propertyAttributeList);

    OCSPropertyRuntimeInfo *info = [[OCSPropertyRuntimeInfo alloc] initWithProperty:factoryCallStackProperty];
    SEL getterSelector = NSSelectorFromString(info.customGetter ?: name);
    Method getterMethod = class_getInstanceMethod(origin, getterSelector);
    class_addMethod(destination, getterSelector, method_getImplementation(getterMethod), method_getTypeEncoding(getterMethod));

    if (!info.readOnly) {
        SEL setterSelector = NSSelectorFromString(info.customSetter ?: [self getSetterName:name]);
        Method setterMethod = class_getInstanceMethod(origin, setterSelector);
        class_addMethod(destination, setterSelector, method_getImplementation(setterMethod), method_getTypeEncoding(setterMethod));
    }
}

+ (NSString *) getSetterName:(NSString *)name {
    NSString *allButFirst = [name substringFromIndex:1];
    NSString *first = [[name substringToIndex:1] uppercaseString];

    return [NSString stringWithFormat:@"set%@%@:", first, allButFirst];
}

@end
