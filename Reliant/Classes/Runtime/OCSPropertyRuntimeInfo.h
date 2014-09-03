//
// Created by Michael Seghers on 1/11/13.
//


#import <Foundation/Foundation.h>
#import <objc/message.h>

/**
Transforms an objc_property_t struct into an ObjectiveC object.

This class is private API.
*/
@interface OCSPropertyRuntimeInfo : NSObject

/**
Initializes the object based on the given property.

@param property the property to base this instance's information on
*/
- (instancetype) initWithProperty:(objc_property_t) property;

/**
The name of the property
*/
@property (nonatomic, readonly) NSString *name;

/**
The type of the property
*/
@property (nonatomic, readonly) NSString *objectType;

/**
A custom getter method, if any is specified
*/
@property (nonatomic, readonly) NSString *customGetter;

/**
A custom setter method, if any is specified
*/
@property (nonatomic, readonly) NSString *customSetter;

/**
The iVar used to back this property
*/
@property (nonatomic, readonly) NSString *iVar;

/**
YES if the property is readonly, NO otherwise
*/
@property (nonatomic, readonly) BOOL readOnly;

/**
YES if the property is an object type, NO if it is scalar
*/
@property (nonatomic, readonly) BOOL isObject;

@end