//
// Created by Michael Seghers on 28/08/14.
// Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import "Info.h"


@implementation Info {

}

- (id)init {
    self = [super init];
    if (self) {
        self.message = @"This is the default info value";
    }
    return self;
}

@end