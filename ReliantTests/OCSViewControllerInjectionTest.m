//
//  OCSViewControllerInjectionTest.m
//  Reliant
//
//  Created by Michael Seghers on 27/10/13.
//
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "OCSApplicationContext.h"
#import "OCSConfigurator.h"

@interface SimpleViewController : UIViewController

- (id)initWithContext:(OCSApplicationContext *) context;

@property (nonatomic) BOOL viewWasLoaded;
@property (nonatomic, strong) NSString *injected;

@end

@interface OCSViewControllerInjectionTest : XCTestCase {
    id<OCSConfigurator> _configurator;
    OCSApplicationContext *_context;
}

@end

@implementation OCSViewControllerInjectionTest

- (void)setUp
{
    [super setUp];
    _configurator = mockProtocol(@protocol(OCSConfigurator));
    _context = [[OCSApplicationContext alloc] initWithConfigurator:_configurator];
    [given([_configurator objectKeys]) willReturn:@[@"injected"]];

}

- (void) testViewShouldNotLoad {
    SimpleViewController *svc = [[SimpleViewController alloc] initWithContext:_context];
    XCTAssertFalse(svc.viewWasLoaded, @"View should not be loaded after mere initialization");
}

- (void) testViewControllerIsBeingInjected {
    [given([_configurator objectForKey:@"injected" inContext:_context]) willReturn:@"InjectedString"];

    
    SimpleViewController *svc = [[SimpleViewController alloc] initWithContext:_context];
    XCTAssertEqual(svc.injected, @"InjectedString", @"The injectable property was not injected");
}

- (void) testViewControllerInjectionExcludesExcludedProperties {
    UIViewController *controller = [[SimpleViewController alloc] initWithContext:_context];
    XCTAssertNotNil(controller, @"Controller should init");
    [verify(_configurator) objectForKey:@"injected" inContext:_context];
    [verifyCount(_configurator, never()) objectForKey:(id)isNot(@"injected") inContext:_context];
}

- (void)tearDown
{
    [super tearDown];
}



@end

@implementation SimpleViewController

- (id)initWithContext:(OCSApplicationContext *) context
{
    self = [super init];
    if (self) {
        [context performInjectionOn:self];
    }
    return self;
}

- (void)viewDidLoad {
    self.viewWasLoaded = YES;
}


@end
