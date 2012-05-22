//
//  OCSConfiguratorFromClass.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OCSConfigurator.h"


@class OCSApplicationContext;

@interface OCSConfiguratorFromClass : NSObject<OCSConfigurator>

- (id)initWithClass:(Class) configuratorClass;

@end
