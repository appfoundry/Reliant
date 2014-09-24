//
//  Greeter.h
//  HelloReliant
//
//  Created by Bart Vandeweerdt on 09/09/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Greeter <NSObject>

- (NSString *)sayHelloTo:(NSString *)name;

@end
