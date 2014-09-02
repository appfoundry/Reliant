//
// Created by Michael Seghers on 23/08/14.
//

#import <Foundation/Foundation.h>


@interface OCSRuntimeMagic : NSObject

+ (void) copyPropertyNamed:(NSString *) name fromClass:(Class) origin toClass:(Class) destination;

@end