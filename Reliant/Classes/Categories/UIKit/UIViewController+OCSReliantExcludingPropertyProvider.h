//
//  UIViewController+OCSReliantExcludingPropertyProvider.h
//  Reliant
//
//  Created by Michael Seghers on 27/10/13.
//
//

#import <UIKit/UIKit.h>
#import "OCSReliantExcludingPropertyProvider.h"

/**
Category to make UIViewController adopt OCSReliantExcludingPropertyProvider.

Specific ignored properties are:
- tabBarItem
- title
- toolbarItems
- view
- aggregateStatisticsDisplayCountKey
- nibName
- storyboard
- parentViewController
- modalTransitionView
- mutableChildViewControllers
- childModalViewController
- parentModalViewController
- searchDisplayController
- dropShadowView
- afterAppearanceBlock
- transitioningDelegate
- customTransitioningView

@see NSObject(OCSReliantExcludingPropertyProvider)
*/
@interface UIViewController (OCSReliantExcludingPropertyProvider) <OCSReliantExcludingPropertyProvider>

@end
