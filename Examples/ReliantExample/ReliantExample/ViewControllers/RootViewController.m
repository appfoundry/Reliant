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
@property (nonatomic, strong) IBOutlet UIButton *pushButton;
@end

@implementation RootViewController {

}

- (void)awakeFromNib {
    [self ocsInject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.pushButton setTitle:[_stringProvider buttonString] forState:UIControlStateNormal];
}

@end