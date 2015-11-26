//
// Created by Michael Seghers on 24/08/14.
//

#import <objc/runtime.h>
#import "NSObject+OCSReliantContextBinding.h"
#import "OCSObjectContext.h"
#import "OCSConfigurator.h"
#import "OCSConfiguratorFromClass.h"


@implementation NSObject (OCSReliantContextBinding)

static char ocsObjectContextKey;

- (id<OCSObjectContext>)ocsObjectContext {
    return objc_getAssociatedObject(self, &ocsObjectContextKey);
}

- (void)setOcsObjectContext:(id<OCSObjectContext>)ocsObjectContext {
    objc_setAssociatedObject(self, &ocsObjectContextKey, ocsObjectContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:(Class)factoryClass {
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:factoryClass parentContext:nil];
}

- (void)ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:(Class)factoryClass parentContext:(id <OCSObjectContext>)parentContext {
    id<OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:factoryClass];
    self.ocsObjectContext = [[OCSObjectContext alloc] initWithConfigurator:configurator parentContext:parentContext];
    [self.ocsObjectContext start];
}

@end