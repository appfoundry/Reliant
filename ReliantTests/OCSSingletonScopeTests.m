//
//  OCSSingletonScopeTests.m
//  Reliant
//
//  Created by Michael Seghers on 26/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//

#import "OCSSingletonScopeTests.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#if (TARGET_OS_IPHONE) 
#import <UIKit/UIApplication.h>
#endif
#import "OCSSingletonScope.h"

@implementation OCSSingletonScopeTests {
    OCSSingletonScope *_scope;
}

- (void) setUp {
    [super setUp];
    
    _scope = [[OCSSingletonScope alloc] init];
}

- (void) testRegister {
    id object = [[NSObject alloc] init];
    [_scope registerObject:object forKey:@"SomeObjectKey"];
    
    id result =  [_scope objectForKey:@"SomeObjectKey"];

    XCTAssertEqual(object, result, @"object should be returned as is");
}

- (void) testAllKeys {
    [_scope registerObject:@"one" forKey:@"1"];
    [_scope registerObject:@"two" forKey:@"2"];
    assertThat([_scope allKeys], allOf(hasCountOf(2), hasItems(@"1", @"2", nil), nil));
}

#if (TARGET_OS_IPHONE) 
- (void) testMemoryWarning {
    id object = [[NSObject alloc] init];
    [_scope registerObject:object forKey:@"SomeObjectKey"];
    
    id result =  [_scope objectForKey:@"SomeObjectKey"];
    XCTAssertEqual(object, result, @"object should be returned as is");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
    
    result =  [_scope objectForKey:@"SomeObjectKey"];
    XCTAssertNil(result, @"Singleton Scope must not hold any objects after a mem warning");
}
#endif

@end
