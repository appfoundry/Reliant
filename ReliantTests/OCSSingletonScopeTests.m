//
//  OCSSingletonScopeTests.m
//  Reliant
//
//  Created by Michael Seghers on 26/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//

#import "OCSSingletonScopeTests.h"

#if (TARGET_OS_IPHONE) 
#import <UIKit/UIApplication.h>
#endif
#import "OCSSingletonScope.h"

@implementation OCSSingletonScopeTests {
    OCSSingletonScope *scope;
}

- (void) setUp {
    [super setUp];
    
    scope = [[OCSSingletonScope alloc] init];
}

- (void) tearDown {
    [scope release];
    scope = nil;
    
    [super tearDown];
}

- (void) testRegister {
    id object = [[NSObject alloc] init];
    [scope registerObject:object forKey:@"SomeObjectKey"];
    
    id result =  [scope objectForKey:@"SomeObjectKey"];
    STAssertEquals(object, result, @"object should be returned as is");
}

#if (TARGET_OS_IPHONE) 
- (void) testMemoryWarning {
    id object = [[NSObject alloc] init];
    [scope registerObject:object forKey:@"SomeObjectKey"];
    
    id result =  [scope objectForKey:@"SomeObjectKey"];
    STAssertEquals(object, result, @"object should be returned as is");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
    
    result =  [scope objectForKey:@"SomeObjectKey"];
    STAssertNil(result, @"Singleton Scope must not hold any objects after a mem warning");
}
#endif

@end
