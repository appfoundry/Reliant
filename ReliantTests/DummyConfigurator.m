//
//  DummyConfigurator.m
//  Reliant
//
//  Created by Michael Seghers on 29/10/13.
//
//

#import "DummyConfigurator.h"
#import "TestObject.h"

@implementation DummyConfigurator

- (NSObject *) createEagerSingletonVerySmartName {
    return [[NSObject alloc] init];
}

- (TestObject *) createEagerSingletonNeverInjectedByOthers {
    return [[TestObject alloc] init];
}

- (NSArray *) aliasesForVerySmartName {
    return [NSArray arrayWithObjects:@"aliasForVerySmartName", @"justAnotherNameForVerySmartName", nil];
}

- (NSArray *) createPrototypeUnbelievableOtherSmartName {
    return [[NSMutableArray alloc] init];
}

- (NSDictionary *) createSingletonLazyOne {
    return [[NSMutableDictionary alloc] init];
}

- (ObjectWithInjectables *) createEagerSingletonSuper {
    return [[ObjectWithInjectables alloc] initWithVerySmartName:[self createEagerSingletonVerySmartName]];
}

- (ExtendedObjectWithInjectables *) createEagerSingletonExtended {
    return [[ExtendedObjectWithInjectables alloc] init];
}

- (id) createWithBadName {
    return @"WRONG";
}


- (id) createSingletonSomeObjectWithSuper:(ObjectWithInjectables *) someSuper andExtended:(ExtendedObjectWithInjectables *) extended {
    return @"WRONG AGAIN";
}

- (id) createPrototypeWithParameter:(id) param {
    return @"WRONG AGAIN AGAIN";
}

@end

@implementation ObjectWithInjectables

@synthesize verySmartName;

- (id) initWithVerySmartName:(NSObject *)averySmartName {
    self = [super init];
    if (self) {
        verySmartName = averySmartName;
    }
    return self;
}

@end


@implementation ExtendedObjectWithInjectables

@synthesize unbelievableOtherSmartName;

@end