//
// Created by Michael Seghers on 28/08/14.
//

#import <Foundation/Foundation.h>

@protocol OCSBoundContextLocator;


@interface OCSBoundContextLocatorFactory : NSObject

+ (instancetype)sharedBoundContextLocatorFactory;

@property (nonatomic, strong) id<OCSBoundContextLocator> contextLocator;

@end