//
// Created by Michael Seghers on 01/09/14.
//

#import <Foundation/Foundation.h>

@protocol OCSObjectContext;

@protocol OCSContextRegistry <NSObject>

- (void)registerContext:(id <OCSObjectContext>)context;
- (id<OCSObjectContext>)contextForName:(NSString *)name;

@end