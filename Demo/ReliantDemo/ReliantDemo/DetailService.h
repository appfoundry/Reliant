//
//  DetailService.h
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@protocol DetailService <NSObject>

- (Person *) personForKey:(NSString *) key;

@end
