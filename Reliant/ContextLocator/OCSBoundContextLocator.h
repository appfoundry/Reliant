//
// Created by Michael Seghers on 24/08/14.
//

#import <Foundation/Foundation.h>

@protocol OCSObjectContext;

@protocol OCSBoundContextLocator <NSObject>

- (id<OCSObjectContext>) locateBoundContextForObject:(NSObject *)object;
- (BOOL) canLocateBoundContextForObject:(NSObject *)object;

@end