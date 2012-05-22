//
//  OCSSingletonScope.m
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//

#import "OCSSingletonScope.h"


@implementation OCSSingletonScope {
    NSMutableDictionary *_objectRegistry;
}

static OCSSingletonScope *sharedOCSSingletonScope = nil;

+ (OCSSingletonScope *) sharedOCSSingletonScope {
	@synchronized(self)	{
		if (sharedOCSSingletonScope == nil) {
			sharedOCSSingletonScope = [[self alloc] init];
		}
	}
    
    return sharedOCSSingletonScope;
}

+ (id) allocWithZone:(NSZone *)zone {
	@synchronized(self)	{
		if (sharedOCSSingletonScope == nil)	{
			sharedOCSSingletonScope = [super allocWithZone:zone];
			return sharedOCSSingletonScope;
		}
	}
   
	return nil;
}

- (id) copyWithZone:(NSZone *)zone {
	return self;
}

 
- (id) init {
    self = [super init];
    if (self) {
        _objectRegistry = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id) objectForKey:(NSString *)key {
    return [_objectRegistry objectForKey:key];
}

- (void) registerObject:(id)object forKey:(NSString *)key {
    [_objectRegistry setObject:object forKey:key];
}

- (void)dealloc
{
    [_objectRegistry release];
    [super dealloc];
}
@end
