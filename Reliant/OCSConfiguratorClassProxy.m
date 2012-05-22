//
//  OCSConfiguratorClassProxy.m
//  Reliant
//
//  Created by Michael Seghers on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OCSConfiguratorClassProxy.h"

#import "OCSConfiguratorConstants.h"

@implementation OCSConfiguratorClassProxy {
    id _proxiedConfigurator;
    NSMutableDictionary *_singletongRegistry;
}


- (id)initWithConfiguratorInstance:(id)instance {
    _proxiedConfigurator = [instance retain];
    _singletongRegistry = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_proxiedConfigurator respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSString *methodName = NSStringFromSelector(invocation.selector);
    if ([methodName hasPrefix:SINGLETON_PREFIX] && [invocation.methodSignature methodReturnType][0] == '@') {
        NSString *key = [methodName substringFromIndex:SINGLETON_PREFIX.length];
        
        id exitingSingleton = [_singletongRegistry objectForKey:key];
        if (exitingSingleton) {
            [invocation setReturnValue:&exitingSingleton];
        } else {
            id returnValue;
            [invocation invokeWithTarget:_proxiedConfigurator];
            [invocation getReturnValue:&returnValue];
            [_singletongRegistry setObject:returnValue forKey:key];
        }
    }
}

- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel {
    NSMethodSignature *methodSignature = [_proxiedConfigurator methodSignatureForSelector:sel];
    NSLog(@"Method signature %s", methodSignature.methodReturnType);
    
    return methodSignature;
}

-(Class)class {
    NSLog(@"[proxy.class]\n");
    return [_proxiedConfigurator class];
}

-(Class)superclass {
    NSLog(@"[proxy.superclass]\n");
    return [_proxiedConfigurator superclass];
}

-(BOOL)isKindOfClass:(Class)aClass {
    NSLog(@"[proxy.ikoc]\n");
    return [_proxiedConfigurator isKindOfClass:aClass];
}

- (void)dealloc
{
    [_proxiedConfigurator release];
    [_singletongRegistry release];
    [super dealloc];
}

@end
