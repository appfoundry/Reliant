//
//  ControllerTracker.h
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControllerTracker : NSObject

@property (nonatomic, readonly) NSUInteger totalTimesLoaded;

- (void) recordNewViewDidLoad;

@end
