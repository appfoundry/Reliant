//
//  OCSConfiguratorConstants.h
//  Reliant
//
//  Created by Michael Seghers on 21/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//


#ifndef Reliant_OCSConfiguratorConstants_h

/**
 The prefix used in OCSConfiguratorFromClass to detect a method which will create a lazy singleton.
 */
#define LAZY_SINGLETON_PREFIX @"createSingleton"

/**
 The prefix used in OCSConfiguratorFromClass to detect a method which will create an eager singleton.
 */
#define EAGER_SINGLETON_PREFIX @"createEagerSingleton"


/**
 The prefix used in OCSConfiguratorFromClass to detect a method which will create a prototype.
 */
#define PROTOTYPE_PREFIX @"createPrototype"

/**
 The prefix used in OCSConfiguratorFromClass to call optional alias methods for a certain object.
 */
#define ALIAS_METHOD_PREFIX @"aliasesFor"

#define Reliant_OCSConfiguratorConstants_h
#endif
