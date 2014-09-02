//
// Created by Michael Seghers on 28/08/14.
// Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import "AppConfiguration.h"
#import "StringProvider.h"
#import "DefaultStringProvider.h"
#import "OCSDefinition.h"


@implementation AppConfiguration {

}

- (id<StringProvider>)createSingletonStringProvider {
    return [[DefaultStringProvider alloc] init];
}

- (NSString *) contextName {
    return @"AppContext";
}

@end