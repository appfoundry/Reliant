//
// Created by Alex Manarpies on 13/12/15.
//

#import "NCMIConfiguration.h"
#import "TestObject.h"

@implementation NCMIConfiguration

-(TestObject *)createSingletonTestObject {
    return [[TestObject alloc] init];
}

@end