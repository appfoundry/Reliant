//
// Created by Jens Goeman on 21/05/14.
//

#import "OCSPrototypeScope.h"

@implementation OCSPrototypeScope {
    NSArray *_empty;
}

- (id)init {
    self = [super init];
    if (self) {
        _empty = @[];
    }

    return self;
}


- (id)objectForKey:(NSString *)key {
    return nil;
}

- (void)registerObject:(id)object forKey:(NSString *)key {
}

- (NSArray *)allKeys {
    return _empty;
}

@end