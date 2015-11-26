//
// Created by Michael Seghers on 28/08/14.
// Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import "TabBarConfiguration.h"
#import "DetailViewModel.h"
#import "DefaultDetailViewModel.h"
#import "OCSObjectContext.h"
#import "NSObject+OCSReliantContextBinding.h"
#import "OCSBoundContextLocator.h"
#import "AppConfiguration.h"


@implementation TabBarConfiguration {

}

- (id<DetailViewModel>) createSingletonDetailViewModel {
    return [[DefaultDetailViewModel alloc] init];
}

- (Class)parentContextConfiguratorClass {
    return [AppConfiguration class];
}

@end