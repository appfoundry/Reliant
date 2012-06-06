//
//  Person.m
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize key = _key, name = _name;

- (id)initWithKey:(NSString *) key andName:(NSString *) name
{
    self = [super init];
    if (self) {
        _key = key;
        _name = name;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@", _key, _name];
}

@end
