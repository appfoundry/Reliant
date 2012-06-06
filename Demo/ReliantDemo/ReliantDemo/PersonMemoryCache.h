//
//  PersonMemoryCache.h
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface PersonMemoryCache : NSObject

@property (nonatomic, readonly, copy) NSDictionary *personsByKey; 

- (void) addPerson:(Person *) person;
- (void) removePerson:(Person *) person;

@end
