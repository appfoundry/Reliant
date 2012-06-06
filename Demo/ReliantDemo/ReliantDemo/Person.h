//
//  Person.h
//  ReliantDemo
//
//  Created by Michael Seghers on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, readonly) NSString *key;
@property (nonatomic, retain) NSString *name;

- (id)initWithKey:(NSString *) key andName:(NSString *) name;

@end
