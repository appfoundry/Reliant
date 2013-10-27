//
//  OCSViewControllerInjectionTest.m
//  Reliant
//
//  Created by Michael Seghers on 27/10/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
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

@interface OCSViewControllerInjectionTest : SenTestCase {
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
}

- (void) testViewShouldNotLoad {
    SimpleViewController *svc = [[SimpleViewController alloc] initWithContext:_context];
    STAssertFalse(svc.viewWasLoaded, @"View should not be loaded after mere initialization");
}

- (void) testViewControllerIsBeingInjected {
    [given([_configurator objectForKey:@"injected" inContext:_context]) willReturn:@"InjectedString"];
    
    SimpleViewController *svc = [[SimpleViewController alloc] initWithContext:_context];
    STAssertEquals(svc.injected, @"InjectedString", @"The injectable property was not injected");
}

- (void) testViewControllerInjectionExcludesExcludedProperties {
    [[SimpleViewController alloc] initWithContext:_context];
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
