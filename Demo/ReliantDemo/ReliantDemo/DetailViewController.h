//
//  DetailViewController.h
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ControllerTracker;
@class Person;
@protocol DetailService;

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) ControllerTracker *controllerTracker;
@property (nonatomic, retain) id<DetailService> couchPatatoe;

- (void) setPersonKey:(NSString *) key;

@end
