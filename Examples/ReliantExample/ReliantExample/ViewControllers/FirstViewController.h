//
//  FirstViewController.h
//  ReliantExample
//
//  Created by Michael Seghers on 28/08/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewModel;

@interface FirstViewController : UIViewController

//Publicly visible property which will be injected from the tab bar context.
@property (nonatomic, strong) id<DetailViewModel> detailViewModel;

@end
