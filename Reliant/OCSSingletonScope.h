//
//  OCSSingletonScope.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCSScope.h"

@interface OCSSingletonScope : NSObject<OCSScope>

+ (OCSSingletonScope *) sharedOCSSingletonScope;

@end
