//
//  ContextHoldingTabBarController.m
//  ReliantExample
//
//  Created by Michael Seghers on 28/08/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <Reliant/Reliant.h>
#import "ContextHoldingTabBarController.h"
#import "NSObject+OCSReliantContextBinding.h"
#import "TabBarConfiguration.h"

@interface ContextHoldingTabBarController ()

@end

@implementation ContextHoldingTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSObject<UIApplicationDelegate> *del = [UIApplication sharedApplication].delegate;
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[TabBarConfiguration class] parentContext:[del ocsObjectContext]];
}

@end
