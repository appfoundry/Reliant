//
//  SecondViewController.m
//  ReliantExample
//
//  Created by Michael Seghers on 28/08/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <Reliant/Reliant.h>
#import "SecondViewController.h"
#import "DetailViewModel.h"
#import "Info.h"

@interface SecondViewController () {
}

//Invisible property which will be injected from the tab bar context.
@property (nonatomic, strong) id<DetailViewModel> detailViewModel;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocsInject];
    self.title = [NSString stringWithFormat:@"- %@ -", self.detailViewModel.info.message];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
