//
//  OCSDefaultBootstrapperTests.m
//  Reliant
//
//  Created by Michael Seghers on 03/06/16.
//
//

#import <XCTest/XCTest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "Reliant.h"
#import "OCSDefaultBootstrapper.h"


@interface OCSDefaultBootstrapperTests : XCTestCase {
    OCSDefaultBootstrapper *bootstrapper;
}

@property (nonatomic, strong) NSString *astring;

@end

@interface DefaultBootstrapperContextConfiguration : NSObject<OCSConfigurationClass>

@end

@implementation OCSDefaultBootstrapperTests

- (void)setUp {
    [super setUp];
    bootstrapper = [[OCSDefaultBootstrapper alloc] init];
}

- (void)testBootstrapReturnsBoundContext {
    id<OCSObjectContext> context = [bootstrapper bootstrapObjectContextWithConfigurationFromClass:[DefaultBootstrapperContextConfiguration class] bindOnObject:self];
    assertThat(context, is(sameInstance(self.ocsObjectContext)));
}

- (void)testBootstrapAndInjectAlsoInjectsTheObject {
    [bootstrapper bootstrapObjectContextWithConfigurationFromClass:[DefaultBootstrapperContextConfiguration class] bindAndInjectObject:self];
    assertThat(self.astring, equalTo(@"injected!"));
}

@end


@implementation DefaultBootstrapperContextConfiguration

- (NSString *)createSingletonAstring {
    return @"injected!";
}

- (NSString *)contextName {
    return @"DefaultBootstrapperContext";
}

@end