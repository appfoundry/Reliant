//
// Created by Alex Manarpies on 05/12/15.
// Copyright (c) 2015 Reliant. All rights reserved.
//

#import <Reliant/Reliant.h>

#import "RandomViewController.h"
#import "RandomViewModel.h"
#import "FibonacciViewModel.h"
#import "NestedConfiguration.h"
#import "AppDelegate.h"

@interface RandomViewController ()
@property(nonatomic, strong) FibonacciViewModel *fibonacciViewModel;
@property(nonatomic, strong) RandomViewModel *randomViewModel;

@property(nonatomic, weak) IBOutlet UILabel *label;
@end

@implementation RandomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // NOTE:
    // Fetching the parent context like this is pretty ugly. Is there another way?
    // Isn't it preferable to define the parent externally, anyway?
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[NestedConfiguration class] parentContext:[(AppDelegate *) [UIApplication sharedApplication].delegate ocsObjectContext]];
    [self ocsInject];

    // Fetch a random number
    self.label.text = [NSString stringWithFormat:@"%@\nRandom number: %d\nFibonacci: %@", self, self.randomViewModel.number, [self.fibonacciViewModel fibonacciSequenceOfLength:3]];
}

@end