//
//  AppDelegate.h
//  HelloReliant
//
//  Created by Bart Vandeweerdt on 09/09/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Greeter.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<Greeter> greeter;

@end
