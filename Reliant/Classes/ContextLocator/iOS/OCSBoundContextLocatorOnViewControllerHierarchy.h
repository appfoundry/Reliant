//
// Created by Michael Seghers on 24/08/14.
//

#import <Foundation/Foundation.h>
#import "OCSBoundContextLocator.h"

/**
An OCSBoundContextLocator which locates an object context in a view controller hierarchy. When the
locateBoundContextForObject: method receives a UIViewController, the given view controller's parent hierarchy is
queried for a bound context. When a context is found the search stops and returns that context. When no parent has a
bound context, nil is returned.
*/
@interface OCSBoundContextLocatorOnViewControllerHierarchy : NSObject<OCSBoundContextLocator>
@end