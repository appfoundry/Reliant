//
//  OCSReliantExcludingPropertyProvider.h
//  Reliant
//
//  Created by Michael Seghers on 27/10/13.
//
//

#import <Foundation/Foundation.h>

@protocol OCSReliantExcludingPropertyProvider <NSObject>

+ (BOOL) OCS_reliantShouldIgnorePropertyWithName:(NSString *) name;

@end
