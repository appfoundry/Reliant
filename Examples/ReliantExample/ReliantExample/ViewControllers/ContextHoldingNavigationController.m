//
//  ContextHoldingNavigationController.m
//  ReliantExample
//
//  Created by Michael Seghers on 24/06/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

#import "ContextHoldingNavigationController.h"
#import "NavigationConfiguration.h"

@implementation ContextHoldingNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initContextHoldingNavigationController];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initContextHoldingNavigationController];
    }
    return self;
}

- (void)_initContextHoldingNavigationController {
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NavigationConfiguration class]];
}

@end
