//
// Created by Michael Seghers on 24/08/14.
//

#import <Foundation/Foundation.h>

@class OCSObjectContext;

@interface NSObject (OCSReliantContextBinding)

@property (nonatomic, strong) OCSObjectContext *ocsObjectContext;

- (void)ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:(Class) factoryClass;

@end