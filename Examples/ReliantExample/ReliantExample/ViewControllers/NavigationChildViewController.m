//
//  NavigationChildViewController.m
//  ReliantExample
//
//  Created by Michael Seghers on 24/06/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

#import <Reliant/Reliant.h>
#import "NavigationChildViewController.h"
#import "ChildConfiguration.h"
#import "ColorService.h"
#import "StringProvider.h"

@interface NavigationChildViewController ()

@property (nonatomic, strong) id<ColorService> colorService;
@property (nonatomic, strong) id<StringProvider> emojiStringProvider;
@property (strong, nonatomic) IBOutlet UILabel *emojiLabel;

@end

@implementation NavigationChildViewController

- (void)awakeFromNib {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[ChildConfiguration class] parentContext:self.navigationController.ocsObjectContext];
    [self ocsInject];
    self.view.backgroundColor = self.colorService.fancyColor;
    self.title = [self.emojiStringProvider provideString];
    self.emojiLabel.text = self.title;
}

@end
