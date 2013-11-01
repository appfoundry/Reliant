//
// Created by Michael Seghers on 1/11/13.
//


#import <Foundation/Foundation.h>

@class OCSPropertyRuntimeInfo;

@interface OCSClassRuntimeInfo : NSObject

- (instancetype) initWithClass:(Class) class;
- (void) enumeratePropertiesWithBlock:(void(^)(OCSPropertyRuntimeInfo *)) block;

@end