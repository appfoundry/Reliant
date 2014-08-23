//
// Created by Michael Seghers on 22/08/14.
//

@class OCSDefinition;
@class OCSApplicationContext;

@protocol OCSObjectFactory <NSObject>

- (id)createObjectForDefinition:(OCSDefinition *)definition;
- (void)bindToContext:(OCSApplicationContext *)context;

@end