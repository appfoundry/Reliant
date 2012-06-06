//
//  ControllerTracker.m
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControllerTracker.h"

@implementation ControllerTracker {
    NSUInteger _totalTimesLoaded;
}

@synthesize totalTimesLoaded = _totalTimesLoaded;

- (void)recordNewViewDidLoad {
    _totalTimesLoaded++;
}

@end
