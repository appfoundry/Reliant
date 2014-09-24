//
//  MyObjectFactory.m
//  HelloReliant
//
//  Created by Bart Vandeweerdt on 09/09/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import "AppConfiguration.h"
#import "FriendlyGreeter.h"

@implementation AppConfiguration

- (id<Greeter>) createSingletonGreeter {
    return [[FriendlyGreeter alloc] init];
}

@end
