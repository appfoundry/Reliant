//
// Created by Michael Seghers on 02/09/14.
// Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <Reliant/NSObject+OCSReliantInjection.h>
#import "RootViewController.h"
#import "StringProvider.h"
#import "ContextHoldingTabBarController.h"
#import "SecondViewController.h"
#import "FirstViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) id<StringProvider> stringProvider;
@end

@implementation RootViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocsInject];

    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 200, 50);
    [button setTitle:[_stringProvider buttonString] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushToNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)pushToNext:(UIButton *)button {
    FirstViewController *first = [[FirstViewController alloc] init];
    SecondViewController *second = [[SecondViewController alloc] init];
    ContextHoldingTabBarController *tabBarController = [[ContextHoldingTabBarController alloc] init];
    tabBarController.viewControllers = @[first, second];
    [self.navigationController pushViewController:tabBarController animated:YES];
}

@end