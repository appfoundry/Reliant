//
//  OCSSingletonScope.m
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCSSingletonScope.h"
#import "OCSDLogger.h"

@implementation OCSSingletonScope {
    NSMutableDictionary *_objectRegistry;
}
 
- (id) init {
    self = [super init];
    if (self) {
        _objectRegistry = [[NSMutableDictionary alloc] init];
#if (TARGET_OS_IOS)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
#endif
    }
    return self;
}

- (id) objectForKey:(NSString *)key {
    return _objectRegistry[key];
}

- (void) registerObject:(id)object forKey:(NSString *)key {
    DLog(@"Registering %@ for key %@ in singleton scope", object, key);
    _objectRegistry[key] = object;
}

- (NSArray *)allKeys {
    return [_objectRegistry allKeys];
}

#if (TARGET_OS_IOS)
- (void) _handleMemoryWarning:(NSNotification *) notification {
    if (self.shouldCleanScopeOnMemoryWarnings) {
        [_objectRegistry removeAllObjects];
    }
}
#endif

- (void)dealloc
{
#if (TARGET_OS_IOS)
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
}
@end
