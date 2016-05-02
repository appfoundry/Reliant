//
//  FakeSharedObject.m
//  Reliant
//
//  Created by Michael Seghers on 02/05/16.
//
//

#import "FakeSharedObject.h"

@implementation FakeSharedObject

+(instancetype)sharedFakeSharedObject {
    static FakeSharedObject *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
