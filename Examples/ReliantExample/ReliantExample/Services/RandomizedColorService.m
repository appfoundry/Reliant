//
//  RandomizedColorService.m
//  ReliantExample
//
//  Created by Michael Seghers on 24/06/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

#import "RandomizedColorService.h"

@implementation RandomizedColorService

- (UIColor *)fancyColor {
    return [UIColor colorWithRed:[self _randomColorComponent] green:[self _randomColorComponent] blue:[self _randomColorComponent] alpha:1.0f];
}

- (CGFloat) _randomColorComponent {
    return (CGFloat)(arc4random_uniform(100) / 100.0);
}

@end
