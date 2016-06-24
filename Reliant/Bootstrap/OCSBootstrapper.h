//
//  OCSBootstrapper.h
//  Reliant
//
//  Created by Michael Seghers on 01/06/16.
//
//

#import <Foundation/Foundation.h>
#import "OCSObjectContext.h"

@protocol OCSBootstrapper <NSObject>

- (id<OCSObjectContext>)bootstrapObjectContextWithConfigurationFromClass:(Class)configuration bindOnObject:(NSObject *)object;
- (id<OCSObjectContext>)bootstrapObjectContextWithConfigurationFromClass:(Class)configuration bindAndInjectObject:(NSObject *)object;

@end
