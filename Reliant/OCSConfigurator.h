//
//  OCSConfigurator.h
//  Reliant
//
//  Created by Michael Seghers on 7/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//


@class OCSObjectContext;
@protocol OCSObjectFactory;
@class OCSDefinition;

/**
 Describes the possibilities of a configurator. 
 
 A configurator is responsible for setting up definitions and creating object instances.
 
 You should never try to retrieve objects while the configurator is still initializing itself.
 @see OCSDefinition
 
 @author Mike Seghers
 */
@protocol OCSConfigurator <NSObject>

/**
 A configurator decides which object factory the application context will use to create objects based on the definitions found in this configurator.
*/
@property (readonly, nonatomic) id<OCSObjectFactory> objectFactory;

/**
 All keys of the definitions found in this configurator. This list includes both keys and aliases.
*/
@property (readonly, nonatomic, copy) NSArray *objectKeys;

/**
All keys of the definitions found in this configurator. This list includes both keys and aliases.
*/
@property (readonly, nonatomic, copy) NSArray *objectKeysAndAliases;



/**
Get a definition for the given key or alias.

@param keyOrAlias the key or alias of the definition you are looking for

@return the definition with the given key or alias, or nil if no such definition exists.
*/
- (OCSDefinition *) definitionForKeyOrAlias:(NSString *) keyOrAlias;


@end
