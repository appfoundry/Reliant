//
// Created by Michael Seghers on 01/09/14.
//

#import <Foundation/Foundation.h>
#import "OCSContextRegistry.h"


@interface OCSDefaultContextRegistry : NSObject<OCSContextRegistry>

+ (instancetype)sharedDefaultContextRegistry;

- (void)registerContext:(id <OCSObjectContext>)context;
- (id <OCSObjectContext>)contextForName:(NSString *)name;

@end