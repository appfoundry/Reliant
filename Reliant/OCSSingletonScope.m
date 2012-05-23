//
//  OCSSingletonScope.m
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


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
