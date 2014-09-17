//
//  FriendlyGreeter.m
//  HelloReliant
//
//  Created by Bart Vandeweerdt on 09/09/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import "FriendlyGreeter.h"

@implementation FriendlyGreeter 

-(NSString *)sayHelloTo:(NSString *)name {
    return [NSString stringWithFormat:@"Hi, %@! How are you?", name];
}

@end
