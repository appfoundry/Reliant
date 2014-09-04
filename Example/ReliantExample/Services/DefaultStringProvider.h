//
// Created by Michael Seghers on 28/08/14.
// Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringProvider.h"

@protocol StringGenerator;


@interface DefaultStringProvider : NSObject<StringProvider>

@property (nonatomic, strong) id<StringGenerator> stringGenerator;

@end