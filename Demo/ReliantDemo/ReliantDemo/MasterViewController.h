//
//  MasterViewController.h
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class ControllerTracker;
@protocol ListService;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, retain) ControllerTracker *controllerTracker;
@property (nonatomic, retain) id<ListService> listService;


@end
