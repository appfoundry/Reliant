//
//  DummyConfigurator.h
//  Reliant
//
//  Created by Michael Seghers on 29/10/13.
//
//

#import <Foundation/Foundation.h>

@interface DummyConfigurator : NSObject

@end

@interface ObjectWithInjectables : NSObject

@property (nonatomic, strong) NSObject *verySmartName;

- (id) initWithVerySmartName:(NSObject *) verySmartName;

@end

@interface ExtendedObjectWithInjectables : ObjectWithInjectables

@property (nonatomic, strong) id unbelievableOtherSmartName;

@end
