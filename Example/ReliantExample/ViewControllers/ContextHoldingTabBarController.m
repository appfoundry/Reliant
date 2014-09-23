//
//  ContextHoldingTabBarController.m
//  ReliantExample
//
//  Created by Michael Seghers on 28/08/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <Reliant/Reliant.h>
#import "ContextHoldingTabBarController.h"
#import "TabBarConfiguration.h"

@interface ContextHoldingTabBarController ()

@end

@implementation ContextHoldingTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initContextHoldingTabBarController];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initContextHoldingTabBarController];
    }
    return self;
}

- (void)_initContextHoldingTabBarController {
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[TabBarConfiguration class]];
}

@end
