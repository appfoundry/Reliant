//
// Created by Michael Seghers on 24/08/14.
//

#import "OCSBoundContextLocatorOnGivenObject.h"
#import "OCSObjectContext.h"
#import "NSObject+OCSReliantContextBinding.h"


@implementation OCSBoundContextLocatorOnGivenObject {

}

- (id <OCSObjectContext>)locateBoundContextForObject:(NSObject *)object {
    return object.ocsObjectContext;
}

@end