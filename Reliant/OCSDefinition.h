//
//  OCSDefinition.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCSScope;

@interface OCSDefinition : NSObject

@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) Class implementingClass;
@property (nonatomic, assign) BOOL singleton;

- (void) addAlias:(NSString *) alias;
- (BOOL) isAlsoKnownWithAlias:(NSString *) alias;

@end
