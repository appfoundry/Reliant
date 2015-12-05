//
// Created by Alex Manarpies on 05/12/15.
// Copyright (c) 2015 Reliant. All rights reserved.
//

#import <Reliant/NSObject+OCSReliantContextBinding.h>
#import <Reliant/NSObject+OCSReliantInjection.h>
#import "RandomViewController.h"
#import "RandomViewModel.h"
#import "FibonacciViewModel.h"
#import "NestedConfiguration.h"

@interface RandomViewController ()
@property(nonatomic, strong) FibonacciViewModel *fibonacciViewModel;
@property(nonatomic, strong) RandomViewModel *randomViewModel;

@property(nonatomic, weak) IBOutlet UILabel *label;
@end

@implementation RandomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NestedConfiguration class]];
    [self ocsInject];

    self.label.text = [NSString stringWithFormat:@"%@\nRandom number: %d\nFibonacci: %@", self, self.randomViewModel.number, [self.fibonacciViewModel fibonacciSequenceOfLength:3]];
}

@end