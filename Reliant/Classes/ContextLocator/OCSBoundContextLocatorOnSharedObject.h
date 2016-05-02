//
//  OCSBoundContextLocatorOnSharedObject.h
//  Reliant
//
//  Created by Michael Seghers on 02/05/16.
//
//

#import <Foundation/Foundation.h>
#import "OCSBoundContextLocator.h"

@interface OCSBoundContextLocatorOnSharedObject : NSObject <OCSBoundContextLocator>

- (instancetype)initWithSharedObject:(NSObject *)sharedObject;

@end
