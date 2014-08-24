//
// Created by Michael Seghers on 22/08/14.
//

@class OCSDefinition;
@class OCSObjectContext;

@protocol OCSObjectFactory <NSObject>

- (id)createObjectForDefinition:(OCSDefinition *)definition;
- (void)bindToContext:(OCSObjectContext *)context;

@end