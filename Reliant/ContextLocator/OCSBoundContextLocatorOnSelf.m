//
// Created by Michael Seghers on 24/08/14.
//

#import "OCSBoundContextLocatorOnSelf.h"
#import "OCSObjectContext.h"
#import "NSObject+OCSReliantContextBinding.h"


@implementation OCSBoundContextLocatorOnSelf {

}

- (id <OCSObjectContext>)locateBoundContextForObject:(NSObject *)object {
    return object.ocsObjectContext;
}

- (BOOL)canLocateBoundContextForObject:(NSObject *)object {
    return YES;
}

@end