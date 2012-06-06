//
//  AppDelegate.m
//  OCSReliantAnalyser
//
//  Created by Michael Seghers on 6/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "OCSApplicationContext.h"
#import "OCSConfiguratorFromClass.h"

@interface DummyFactory : NSObject

@end

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    OCSConfiguratorFromClass *config = [[OCSConfiguratorFromClass alloc] initWithClass:[DummyFactory class]];
    
    OCSApplicationContext *appContext = [[OCSApplicationContext alloc] initWithConfigurator:config];
    
    [appContext start];
}

@end

@implementation DummyFactory

- (id) createSingletonStringThing {
    return @"String";
}

- (id) createEagerSingletonEagerOne {
    return @"OhterString";
}

- (id) createEagerSingletonEagerTwo {
    return @"OhterString2";
}


- (id) createEagerSingletonEagerThree {
    return @"OhterString3";
}


- (id) createEagerSingletonEagerFour {
    return @"OhterString4";
}


@end
