//
//  OCSApplicationContext.h
//  Reliant
//
//  Created by Michael Seghers on 2/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCSDefinition;
@protocol OCSConfigurator;

@interface OCSApplicationContext : NSObject

- (id) initWithConfigurator:(id<OCSConfigurator>) configurator;

- (id) objectForKey:(NSString *) key;
- (void) performInjectionOn:(id) object;
- (BOOL) start;
@end
