//
//  NavigationConfiguration.m
//  ReliantExample
//
//  Created by Michael Seghers on 24/06/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

#import "NavigationConfiguration.h"
#import "EmojiStringProvider.h"

@implementation NavigationConfiguration

- (id<StringProvider>)createPrototypeEmojiStringProvider {
    return [[EmojiStringProvider alloc] init];
}

- (NSString *)contextName {
    return @"NavigationContext";
}

- (NSString *)parentContextName {
    return @"AppContext";
}

@end
