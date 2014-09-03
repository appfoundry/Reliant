//
// Created by Michael Seghers on 28/08/14.
//

#import <Foundation/Foundation.h>

@protocol OCSBoundContextLocator;

/**
Factory for creating and returning a fixed context locator.

This class is private API.
*/
@interface OCSBoundContextLocatorFactory : NSObject

/**
Returns the singleton instance.
*/
+ (instancetype)sharedBoundContextLocatorFactory;

/**
The context locator
*/
@property (nonatomic, readonly) id<OCSBoundContextLocator> contextLocator;

@end