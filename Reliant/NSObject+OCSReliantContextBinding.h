//
// Created by Michael Seghers on 24/08/14.
//

#import <Foundation/Foundation.h>

@protocol OCSObjectContext;

@interface NSObject (OCSReliantContextBinding)

@property (nonatomic, strong) id<OCSObjectContext> ocsObjectContext;

- (void)ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:(Class) factoryClass;

@end