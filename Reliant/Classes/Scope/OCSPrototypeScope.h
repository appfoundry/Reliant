//
// Created by Jens Goeman on 21/05/14.
//

#import <Foundation/Foundation.h>
#import "OCSScope.h"

/**
Prototype scope. Scope which makes sure a new instance of the requested object will always be created by the context this scope belongs to.
*/
@interface OCSPrototypeScope : NSObject <OCSScope>
@end