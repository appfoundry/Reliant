//
//  FibonacciViewController.m
//  Issue10ReviewExample
//
//  Created by Alex Manarpies on 05/12/15.
//  Copyright (c) 2015 Reliant. All rights reserved.
//

#import <Reliant/Reliant.h>

#import "FibonacciViewController.h"
#import "FibonacciViewModel.h"

@interface FibonacciViewController ()
@property(nonatomic) NSUInteger counter;
@property(nonatomic, strong) FibonacciViewModel *fibonacciViewModel;
@property(nonatomic, weak) IBOutlet UILabel *fibonacciLabel;
@end

@implementation FibonacciViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocsInject];
}

- (IBAction)gimmenacciButtonTapped:(UIButton *)sender {
    if (![[sender titleForState:UIControlStateNormal] isEqualToString:@"Gimmemorenacci"]) {
        [sender setTitle:@"Gimmemorenacci" forState:UIControlStateNormal];
    }
    self.counter = self.counter ?: 1;
    self.fibonacciLabel.text = [self.fibonacciViewModel fibonacciSequenceOfLength:++self.counter];
}

@end