//
// Created by Michael Seghers on 28/08/14.
// Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import "DefaultDetailViewModel.h"
#import "StringProvider.h"
#import "NSObject+OCSReliantInjection.h"
#import "Info.h"

@interface DefaultDetailViewModel ()

@property (nonatomic, strong) id<StringProvider> stringProvider;

@end

@implementation DefaultDetailViewModel {

}

@synthesize info;

- (id)init {
    self = [super init];
    if (self) {
        [self ocsInject];
        self.info = [[Info alloc] init];
        self.info.message = [_stringProvider provideString];
    }

    return self;
}

@end