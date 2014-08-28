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
    __weak IBOutlet UITextView *_textView;
}

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ocsInject];
    _textView.text = self.detailViewModel.info.message;
}

@end
