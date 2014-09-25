//
//  AppDelegate.m
//  ReliantExample
//
//  Created by Michael Seghers on 28/08/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <Reliant/OCSObjectContext.h>
#import <Reliant/NSObject+OCSReliantContextBinding.h>
#import "AppDelegate.h"
#import "AppConfiguration.h"
#import "StringProvider.h"
#import "NSObject+OCSReliantInjection.h"
#import "RootViewController.h"

@interface AppDelegate () {

}

@property(nonatomic, strong) id <StringProvider> stringProvider;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[AppConfiguration class]];

    //DEMO: Get an object from your own context (since the previous line binds a context to this AppDelegate):
    id <StringProvider> stringProvider = [self.ocsObjectContext objectForKey:@"StringProvider"];
    NSLog(@"Application is starting, and now has an application wide context, holding a string provider which says: %@", [stringProvider provideString]);

    //DEMO: You can inject the spring provider, by calling ocsInject on self too (the instance you get back is the same as in the previous example
    [self ocsInject];
    NSLog(@"The app delegate is now injected and holds the StringProvider as configured in the AppConfiguration class: %@", [self.stringProvider provideString]);

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
