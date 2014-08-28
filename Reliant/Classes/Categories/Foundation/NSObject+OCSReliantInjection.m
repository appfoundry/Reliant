//
// Created by Michael Seghers on 28/08/14.
//

#import "NSObject+OCSReliantInjection.h"
#import "OCSBoundContextLocatorFactory.h"
#import "OCSBoundContextLocator.h"
#import "OCSObjectContext.h"


@implementation NSObject (OCSReliantInjection)

- (void)ocsInject {
    id <OCSObjectContext> context = [[OCSBoundContextLocatorFactory sharedBoundContextLocatorFactory].contextLocator locateBoundContextForObject:self];
    [context performInjectionOn:self];
}

@end