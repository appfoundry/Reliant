//
// Created by Michael Seghers on 24/08/14.
//

#import <Foundation/Foundation.h>
#import "OCSBoundContextLocator.h"

/**
An OCSBoundContextLocator which groups together other locators, iterating over these locators in the order in which
they were added, until a locator has been found.
*/
@interface OCSBoundContextLocatorChain : NSObject<OCSBoundContextLocator>

/**
@name properties
*/

/**
A list of locators which will be used to locate an OCSObjectContext.
*/
@property (nonatomic, readonly, copy) NSArray *locators;

/**
@name Adding locators
*/

/**
Add the given contextLocator to this chain.
@param contextLocator The OCSBoundContextLocator to be added to the chain of locators.
*/
- (void)addBoundContextLocator:(id<OCSBoundContextLocator>) contextLocator;


@end