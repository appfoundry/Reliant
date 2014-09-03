//
// Created by Michael Seghers on 28/08/14.
//

#import <Foundation/Foundation.h>

/**
This category supplies a convenient way to inject an object which has not been configured by Reliant.

Use this category on objects that are not in an OCSObjectContext. Typically these are instances of classes created by
Cocoa/CocoaTouch or other frameworks that have their own factory mechanisms. For instance a UIViewController that gets
created via a xib or storyboard or by your application code in general.
*/
@interface NSObject (OCSReliantInjection)

/**
Injects this instance's properties with objects known to a located context.

The context which is used to inject is located by using a default OCSBoundContextLocator.

The actual used locator is an OCSBoundContextLocatorChain which uses locators based on the system you are running on.
- For iOS
    - OCSBoundContextLocatorOnGivenObject
    - OCSBoundContextLocatorOnViewControllerHierarchy
    - OCSBoundContextLocatorOnApplicationDelegate
- For OSX this means:
    - OCSBoundContextLocatorOnGivenObject
    - OCSBoundContextLocatorOnOSXApplicationDelegate

Usage of this method is highly recommended, as doing this manually might clutter your code, and make it depend too much
on reliant. Reliant is designed to get out of your way as much as it can.
*/
- (void)ocsInject;

@end