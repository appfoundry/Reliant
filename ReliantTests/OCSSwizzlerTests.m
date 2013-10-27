//
//  OCSSwizzlerTests.m
//  Reliant
//
//  Created by Michael Seghers on 18/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
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

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "OCSSwizzlerTests.h"
#import "OCSSwizzler.h"

//Fully dynamic method for swizzle replacement, uber awesomeness ;-)
static id dynamicJustCallSuper(id self, SEL _cmd) {
    struct objc_super superData;
    superData.receiver = self;
    superData.super_class = [self superclass];//[metaclass superclass];    
    
    return objc_msgSendSuper(&superData, _cmd);
}

@interface SwizzlerClass : NSObject

@property (nonatomic, assign) SEL called;
@property (nonatomic, strong) id object;
@property (nonatomic, assign) long scalar;
@property (nonatomic, assign) NSRange range;

- (void) voidMethodNoArgs;
- (void) voidMethodScalarArg:(long) i;
- (void) voidMethodRangeArg:(NSRange) range;
- (void) voidMethodObjectArg:(id) someObject;
- (void) voidMethodObjectArg:(id) someObject andScalarArg:(long) i;
- (void) voidMethodObjectArg:(id) someObject andRange:(NSRange) range andScalarArg:(long) i;

- (id) objectMethodNoArgsEither;
- (id) objectMethodNoArgs;
- (id) objectMethodScalarArg:(long) i;
- (id) objectMethodObjectArg:(id) someObject;
- (id) objectMethodObjectArg:(id) someObject andScalarArg:(long) i;
- (id) objectMethodObjectArg:(id) someObject andScalarArg:(long) i andRange:(NSRange) range;

- (NSInteger) scalarMethodNoArgs;
- (NSInteger) scalarMethodScalarArg:(long) i;
- (NSInteger) scalarMethodObjectArg:(id) someObject;
- (NSInteger) scalarMethodObjectArg:(id) someObject andScalarArg:(long) i;
- (NSInteger) scalarMethodObjectArg:(id) someObject andRange:(NSRange) range andScalarArg:(long) i;

- (NSRange) rangeMethodNoArgs;
- (NSRange) rangeMethodScalarArg:(long) i;
- (NSRange) rangeMethodObjectArg:(id) someObject;
- (NSRange) rangeMethodObjectArg:(id) someObject andScalarArg:(long) i;
- (NSRange) rangeMethodObjectArg:(id) someObject andScalarArg:(long) i andRange:(NSRange) range;

- (id) someMethod:(int) a withB:(int) b andC: (int) c andD:(int) d andE:(int) e andChars:(char *) f andE:(int) i andId:(id) j;

@end

@interface SwizzlerClassExtended : SwizzlerClass

@end

@interface SwizzlerClassProxy : NSProxy 

- (id) initWithProxy:(SwizzlerClass *) test;

@end

typedef struct {
    int x;
    char * y;
    float z;
} testStruct;


@implementation OCSSwizzlerTests {
    SwizzlerClass *dummy;
}

+ (void)initialize {
/*    swizzleEntireClass([SwizzlerClass class], ^(Method m) {
        NSString *sel = NSStringFromSelector(method_getName(m));
        NSRange methodRange = [sel rangeOfString:@"Method"];
        return (BOOL) (methodRange.location != NSNotFound);
    });*/
}

- (void) setUp {
    dummy = [[SwizzlerClass alloc] init];
}

- (void) tearDown {
    dummy = nil;
}
/*

- (void) testSwizzledVoidMethodNoArgs {
    [dummy voidMethodNoArgs];
    
    STAssertTrue(sel_isEqual(dummy.called, @selector(voidMethodNoArgs)), @"Invocation method wrong, was %@ expected %@", NSStringFromSelector(dummy.called), NSStringFromSelector(@selector(voidMethodNoArgs)));
}

- (void) testSwizzledVoidMethodObjectArg {
    [dummy voidMethodObjectArg:@"SomeObject"];
    
    STAssertTrue(sel_isEqual(dummy.called, @selector(voidMethodObjectArg:)), @"Invocation method wrong, was %@ expected %@", NSStringFromSelector(dummy.called), NSStringFromSelector(@selector(voidMethodObjectArg:)));
    STAssertEqualObjects(dummy.object, @"SomeObject", @"Object not set correctly");
}

- (void) testSwizzledVoidMethodScalarArg {
    [dummy voidMethodScalarArg:101l];
    
    STAssertTrue(sel_isEqual(dummy.called, @selector(voidMethodScalarArg:)), @"Invocation method wrong, was %@ expected %@", NSStringFromSelector(dummy.called), NSStringFromSelector(@selector(voidMethodScalarArg:)));
    STAssertEquals(dummy.scalar, 101l, @"Scalar not set correctly");
}

- (void) testSwizzledVoidMethodRangeArg {
    NSRange range = NSMakeRange(0, 10);
    [dummy voidMethodRangeArg:range];
    
    STAssertTrue(sel_isEqual(dummy.called, @selector(voidMethodRangeArg:)), @"Invocation method wrong, was %@ expected %@", NSStringFromSelector(dummy.called), NSStringFromSelector(@selector(voidMethodRangeArg:)));
    STAssertEquals(dummy.range, range, @"range not set correctly");
}

- (void) testSwizzledRangeMethodNoArg {
    NSRange range = [dummy rangeMethodNoArgs];
    STAssertTrue(sel_isEqual(dummy.called, @selector(rangeMethodNoArgs)), @"Invocation method wrong, was %@ expected %@", NSStringFromSelector(dummy.called), NSStringFromSelector(@selector(rangeMethodNoArgs)));
    STAssertEquals(NSMakeRange(10, 100), range, @"range not correctly returned");
}

- (void) testSwizzleVoidMethodObjectScalarRangeArg {
    NSRange range = NSMakeRange(INT_MAX, INT_MAX - 1);
    [dummy voidMethodObjectArg:@"AAAA" andRange:range andScalarArg:LONG_MAX - 2];
    
    STAssertTrue(sel_isEqual(dummy.called, @selector(voidMethodObjectArg:andRange:andScalarArg:)), @"Invocation method wrong, was %@ expected %@", NSStringFromSelector(dummy.called), NSStringFromSelector(@selector(voidMethodObjectArg:andRange:andScalarArg:)));
    STAssertEquals(dummy.range, range, @"range not set correctly");
    STAssertEquals(dummy.scalar, LONG_MAX - 2, @"scalar not set correctly");
    STAssertEqualObjects(dummy.object, @"AAAA", @"Object not set correctly");
}

- (void) testSwizzledObjectMethodNoArg {
    id object = [dummy objectMethodNoArgs];
    STAssertTrue(sel_isEqual(dummy.called, @selector(objectMethodNoArgs)), @"Invocation method wrong, was %@ expected %@", NSStringFromSelector(dummy.called), NSStringFromSelector(@selector(objectMethodNoArgs)));
    STAssertEqualObjects(@"ObjectReturn", object, @"object not correctly returned");
}


- (void) testSwizzledScalarMethodNoArg {
    long scalar = [dummy scalarMethodNoArgs];
    STAssertTrue(sel_isEqual(dummy.called, @selector(scalarMethodNoArgs)), @"Invocation method wrong, was %@ expected %@", NSStringFromSelector(dummy.called), NSStringFromSelector(@selector(scalarMethodNoArgs)));
    STAssertEquals(LONG_MAX, scalar, @"scalar not correctly returned");
}
*/
- (void) testExtendedClassCreation {
    id<OCSScope> singletonScope = mockProtocol(@protocol(OCSScope));
    id instance = createExtendedConfiguratorInstance([SwizzlerClass class], singletonScope, ^(NSString *name) {
        return YES;
    }, ^(NSString *name) {
        return name;
    }, (IMP) dynamicJustCallSuper);
    
    id returned = [instance objectMethodNoArgs];
    NSLog(@"%@", returned);
    returned = [instance objectMethodNoArgsEither];
    returned = [instance objectMethodNoArgs];
    
    /*SwizzlerClass *instance = [[SwizzlerClassExtended alloc] init];
    id returned = [instance objectMethodObjectArg:@"TestObject" andScalarArg:2039480293l andRange:NSMakeRange(394082, 9083)];
    NSLog(@"%@", returned);*/
    
    
}


/*
- (void) testNSInvocation {
    NSRange range = NSMakeRange(INT_MAX, INT_MAX - 1);
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[dummy methodSignatureForSelector:@selector(voidMethodRangeArg:)]];
    inv.target = dummy;
    inv.selector = @selector(voidMethodRangeArg:);
    void *asVoid = &range;
    [inv setArgument:asVoid atIndex:2];
    [inv invoke];
    
    STAssertEquals(dummy.range, range, @"range not set correctly");
}
*/
/*
- (void) testInvocation {
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[dummy methodSignatureForSelector:@selector(rangeMethodNoArgs)]];
    
    inv.target = dummy;
    inv.selector = @selector(rangeMethodNoArgs);
    
    [inv invoke];
    
    void *range = malloc(sizeof(NSRange));

    [inv getReturnValue:range];
    
    free(range);
    STAssertEquals(NSMakeRange(10, 100), *(NSRange *)range, @"Range doesn't match");
}*/



@end

@implementation SwizzlerClass

@synthesize called = _called, object, range, scalar;

- (void) voidMethodNoArgs {
    NSLog(@"Super void");
    self.called = @selector(voidMethodNoArgs);
}

- (void)voidMethodObjectArg:(id)someObject {
    self.called = @selector(voidMethodObjectArg:);   
    self.object = someObject;
}

- (void)voidMethodScalarArg:(long)i {
    self.called = @selector(voidMethodScalarArg:);
    self.scalar = i;
}

- (void)voidMethodRangeArg:(NSRange) arange {
    self.called = @selector(voidMethodRangeArg:);
    self.range = arange;
}

- (void)voidMethodObjectArg:(id)someObject andScalarArg:(long)i {
    self.called = @selector(voidMethodObjectArg:andScalarArg:);
    self.object = someObject;
    self.scalar = i;
}

- (void)voidMethodObjectArg:(id)someObject andRange:(NSRange)arange andScalarArg:(long)i {
    self.called = @selector(voidMethodObjectArg:andRange:andScalarArg:);
    self.object = someObject;
    self.scalar = i;
    self.range = arange;
}


- (NSRange) rangeMethodNoArgs {
    self.called = @selector(rangeMethodNoArgs);
    return NSMakeRange(10, 100);
}


- (void)setCalled:(SEL) methodCalled {
    if (!_called) {
        _called = methodCalled;
    }
}

- (id) objectMethodNoArgsEither {
    return @"Woot";
}

- (id) objectMethodNoArgs {
    self.called = @selector(objectMethodNoArgs);

    return [NSString stringWithFormat:@"%@%@", [self objectMethodNoArgsEither],  @"ObjectReturn"];
}

- (NSInteger) scalarMethodNoArgs {
    self.called = @selector(scalarMethodNoArgs);
    return LONG_MAX;
}

- (id) objectMethodObjectArg:(id) someObject andScalarArg:(long) i andRange:(NSRange) arange {
    NSLog(@"Super yes seree");
    //[self objectMethodScalarArg:i];
    
    //self.called = @selector(objectMethodObjectArg:andScalarArg:andRange:);
    //self.object = someObject;
    //self.range = arange;
    
    return @"ReturnedObject";
}

- (id) someMethod:(int) a withB:(int) b andC: (int) c andD:(int) d andE:(int) e andChars:(char *) f andE:(int) i andId:(id) j {
    return @"Gelukt";
}

- (id) objectMethodScalarArg:(long) i {
    self.called = @selector(objectMethodObjectArg:andScalarArg:andRange:);
    self.scalar = i;    
    return @"HerYouGo";
}
- (void)dealloc
{
    self.called = nil;
}

@end

@implementation SwizzlerClassProxy {
    SwizzlerClass *_proxied;
}

- (id) initWithProxy:(SwizzlerClass *)test {
    _proxied = test;
    
    return self;
}

- (void) forwardInvocation:(NSInvocation *) invocation {
    [invocation invokeWithTarget:_proxied];
}

- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel {
    return [_proxied methodSignatureForSelector:sel];
}

@end

@implementation SwizzlerClassExtended

- (id) objectMethodObjectArg:(id) someObject andScalarArg:(long) i andRange:(NSRange) arange  {
    NSLog(@"Overriden yes seree");
    id result = [super objectMethodObjectArg:someObject andScalarArg:i andRange:arange];
    NSLog(@"Overriden done");
    return result;
}

- (void) voidMethodNoArgs {
    NSLog(@"Overriden yes seree");
    [super voidMethodNoArgs];
    NSLog(@"Overriden done");
}

@end
