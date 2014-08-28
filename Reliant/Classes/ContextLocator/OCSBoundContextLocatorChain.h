//
// Created by Michael Seghers on 24/08/14.
//

#import <Foundation/Foundation.h>
#import "OCSBoundContextLocator.h"


@interface OCSBoundContextLocatorChain : NSObject<OCSBoundContextLocator>

@property (nonatomic, readonly, copy) NSArray *locators;

- (void)addBoundContextLocator:(id<OCSBoundContextLocator>) contextLocator;


@end