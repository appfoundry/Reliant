//
//  UIResponder+OCSReliantExcludingPropertyProvider.h
//  Reliant
//
//  Created by Michael Seghers on 27/10/13.
//
//

#import <UIKit/UIKit.h>
#import "OCSReliantExcludingPropertyProvider.h"

/**
Category to make UIResponder adopt OCSReliantExcludingPropertyProvider.

Specific ignored properties are:
- restorationIdentifier

@see NSObject(OCSReliantExcludingPropertyProvider)
*/
@interface UIResponder (OCSReliantExcludingPropertyProvider) <OCSReliantExcludingPropertyProvider>

@end
