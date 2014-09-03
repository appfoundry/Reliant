//
//  NSObject+OCSReliantExcludingPropertyProvider.h
//  Reliant
//
//  Created by Michael Seghers on 27/10/13.
//
//

#import <Foundation/Foundation.h>
#import "OCSReliantExcludingPropertyProvider.h"

/**
Category to make NSObject adopt OCSReliantExcludingPropertyProvider.

Specific ignored properties are:
- accessibilityPath
- accessibilityLabel
- accessibilityHint
- accessibilityValue
- accessibilityLanguage
*/
@interface NSObject (OCSReliantExcludingPropertyProvider) <OCSReliantExcludingPropertyProvider>

@end
