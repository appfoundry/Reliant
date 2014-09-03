//
//  OCSSingletonScope.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//


#if (TARGET_OS_IPHONE)
#import <UIKit/UIApplication.h>
#endif

#import "OCSScope.h"

/**
Singleton scope. Scope for holding objects which have one single instance for the object context this scope belongs to.
*/
@interface OCSSingletonScope : NSObject<OCSScope>

@end
