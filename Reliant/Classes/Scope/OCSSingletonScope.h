//
//  OCSSingletonScope.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//


#if (TARGET_OS_IOS)
#import <UIKit/UIApplication.h>
#endif

#import "OCSScope.h"

/**
Singleton scope. Scope for holding objects which have one single instance for the object context this scope belongs to.
*/
@interface OCSSingletonScope : NSObject<OCSScope>

/**
iOS only: When a memory warning is given by the system, reliant can remove all objects from the singleton scope, so
that they become lazy objects. However, this might require a re-injection into current living objects in your application.
You should generally not need this cleanup. The default is NO.
*/
@property (nonatomic) BOOL shouldCleanScopeOnMemoryWarnings;

@end
