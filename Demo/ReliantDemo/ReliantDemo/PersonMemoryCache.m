//
//  PersonMemoryCache.m
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonMemoryCache.h"

#import "Person.h"

@implementation PersonMemoryCache {
    NSMutableDictionary *_persons;
}

@synthesize personsByKey = _persons;

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *keys = [NSArray arrayWithObjects:@"1B34", @"1X36", @"1H56", nil];
        NSArray *names = [NSArray arrayWithObjects:@"John", @"Jane", @"Gill", nil];
        NSMutableArray *persons = [[NSMutableArray alloc] init];
        [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Person *person = [[Person alloc] initWithKey:obj andName:[names objectAtIndex:idx]];
            [persons addObject:person];
        }];

        _persons = [NSMutableDictionary dictionaryWithObjects:persons forKeys:keys];
    }
    return self;
}

- (void) addPerson:(Person *) person {
    [_persons setObject:person forKey:person.key];
}

- (void) removePerson:(Person *)person {
    [_persons removeObjectForKey:person.key];
}

@end
