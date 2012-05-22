//
//  OCSConfiguratorClassProxy.h
//  Reliant
//
//  Created by Michael Seghers on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCSConfiguratorClassProxy : NSProxy

- (id) initWithConfiguratorInstance:(id) instance;

@end
