//
//  OCSConfigurator.h
//  Reliant
//
//  Created by Michael Seghers on 7/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCSApplicationContext;

@protocol OCSConfigurator <NSObject>

@property (nonatomic, assign) BOOL initializing;

- (void) contextLoaded:(OCSApplicationContext *) context;
- (id) objectForKey:(NSString *) keyOrAlias inContext:(OCSApplicationContext *) context;


@end
