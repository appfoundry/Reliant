//
//  FirstViewController.m
//  ReliantExample
//
//  Created by Michael Seghers on 28/08/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <Reliant/NSObject+OCSReliantInjection.h>
#import "FirstViewController.h"
#import "DetailViewModel.h"
#import "Info.h"

@interface FirstViewController () {
}

@end

@implementation FirstViewController

-(void)awakeFromNib {
    [self ocsInject];
    self.title = [NSString stringWithFormat:@"- %@ -", self.detailViewModel.info.message];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
