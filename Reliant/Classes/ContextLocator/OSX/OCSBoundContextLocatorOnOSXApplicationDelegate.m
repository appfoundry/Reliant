//
// Created by Michael Seghers on 28/08/14.
//

#import <AppKit/AppKit.h>
#import "OCSBoundContextLocatorOnOSXApplicationDelegate.h"
#import "NSObject+OCSReliantContextBinding.h"

@implementation OCSBoundContextLocatorOnOSXApplicationDelegate {

}

- (id <OCSObjectContext>)locateBoundContextForObject:(NSObject *)object {
    NSObject<NSApplicationDelegate> *delegate = [[NSApplication sharedApplication] delegate];
    return delegate.ocsObjectContext;
}

@end