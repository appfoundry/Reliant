//
//  ProxyTest.m
//  Reliant
//
//  Created by Michael Seghers on 17/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


#import "ProxyTest.h"

@interface ProxyTestProxy : NSProxy

- (id) initWithProxyTest:(ProxyTest *) test;

@end

@implementation ProxyTest

- (void) someMethod {
    NSLog(@"Original Some method");
}

- (void) callMethodInMethod {
    NSLog(@"Original call method");
    [self someMethod];
}

- (id) returningSomething {
    return @"smdfjklm";
}

- (BOOL) returningScalar {
    return YES;
}

- (NSRange) returningRange {
    return NSMakeRange(0, 1);
}

- (void) test {
    id proxy = [[ProxyTestProxy alloc] initWithProxyTest:self];
    [proxy someMethod];
    [proxy callMethodInMethod];
    [proxy returningSomething];
    [proxy returningScalar];
    [proxy returningRange];
}


@end

@implementation ProxyTestProxy {
    ProxyTest *_proxied;
}

- (id) initWithProxyTest:(ProxyTest *)test {
    _proxied = test;
    
    return self;
}

- (void) forwardInvocation:(NSInvocation *) invocation {
    NSLog(@"Proxy invocation %@", invocation);
    [invocation invokeWithTarget:_proxied];
    
    NSUInteger length = [[invocation methodSignature] methodReturnLength];
    const char *type = [[invocation methodSignature] methodReturnType];
    switch (type[0]) {
        case 'v':
            NSLog(@"void");
            break;
        case '@':
            NSLog(@"Object");
            break;
        default:
            NSLog(@"Unknown %s", type);
            break;
    } 
    
    NSLog(@"Return value length %d", length);
    /*if (length) {
        id value;
        [invocation getReturnValue:&value];
    
        //NSLog(@"After Proxy invocation with result %@", value);
    }*/
}

- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel {
    return [_proxied methodSignatureForSelector:sel];
}

@end