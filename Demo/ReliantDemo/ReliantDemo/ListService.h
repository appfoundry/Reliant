//
//  ListService.h
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@protocol ListService <NSObject>

- (NSArray *) personList;
- (void) addPerson:(Person *) person;
- (void) removePerson:(Person *) person;
- (NSUInteger) countPersons;

@end
