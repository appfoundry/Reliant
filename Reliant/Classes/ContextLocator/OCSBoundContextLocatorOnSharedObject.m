//
//  OCSBoundContextLocatorOnSharedObject.m
//  Reliant
//
//  Created by Michael Seghers on 02/05/16.
//
//

#import "OCSBoundContextLocatorOnSharedObject.h"
#import "NSObject+OCSReliantContextBinding.h"

@interface OCSBoundContextLocatorOnSharedObject () {
    __weak NSObject *_sharedObject;
}

@end

@implementation OCSBoundContextLocatorOnSharedObject

- (instancetype)initWithSharedObject:(NSObject *)sharedObject
{
    self = [super init];
    if (self) {
        _sharedObject = sharedObject;
    }
    return self;
}

- (id<OCSObjectContext>)locateBoundContextForObject:(NSObject *)object {
    return _sharedObject.ocsObjectContext;
}

@end
