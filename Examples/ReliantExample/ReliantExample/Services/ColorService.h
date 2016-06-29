//
//  ColorService.h
//  ReliantExample
//
//  Created by Michael Seghers on 24/06/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorService <NSObject>

@property (nonatomic, readonly, weak) UIColor *fancyColor;

@end
