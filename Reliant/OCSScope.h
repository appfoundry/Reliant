//
//  OCSScope.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCSScope <NSObject>

- (id) objectForKey:(NSString *) key;
- (void) registerObject:(id) object forKey:(NSString *) key;

@end
