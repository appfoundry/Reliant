//
// Created by Jens Goeman on 21/05/14.
//

#import <Foundation/Foundation.h>
#import "OCSApplicationContext.h"

@interface OCSApplicationContext (Protected)

- (id <OCSScope>)scopeForClass:(Class)refClass;

@end