//
// Created by Michael Seghers on 1/11/13.
//


#import <Foundation/Foundation.h>
#import <objc/message.h>


@interface OCSPropertyRuntimeInfo : NSObject

- (instancetype) initWithProperty:(objc_property_t) property;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *objectType;
@property (nonatomic, readonly) NSString *customGetter;
@property (nonatomic, readonly) NSString *customSetter;
@property (nonatomic, readonly) BOOL readOnly;
@property (nonatomic, readonly) BOOL isObject;

@end