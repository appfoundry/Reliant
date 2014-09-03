//
// Created by Michael Seghers on 01/09/14.
//

#import "OCSDefaultContextRegistry.h"
#import "OCSObjectContext.h"


@interface OCSWeakWrapper : NSObject
@property (nonatomic, weak) id object;

+ (instancetype)weakWrapperWithObject:(id)object;
- (instancetype)initWithObject:(id)object;

@end

@implementation OCSDefaultContextRegistry {
    NSMutableDictionary *_contextRegister;
}

- (id)init {
    self = [super init];
    if (self) {
        _contextRegister = [[NSMutableDictionary alloc] init];
    }
    return self;
}


+ (instancetype)sharedDefaultContextRegistry {
    static dispatch_once_t token;
    static OCSDefaultContextRegistry *_instance;
    dispatch_once(&token, ^{
          _instance = [[OCSDefaultContextRegistry alloc] init];
    });
    return _instance;
}

- (void)registerContext:(id <OCSObjectContext>)context {
    _contextRegister[context.name] = [OCSWeakWrapper weakWrapperWithObject:context];
}

- (id <OCSObjectContext>)contextForName:(NSString *)name {
    OCSWeakWrapper *weakRef = _contextRegister[name];
    id<OCSObjectContext> result = nil;
    if (weakRef) {
        result = [weakRef object];
        if (!result) {
            [_contextRegister removeObjectForKey:name];
        }
    }
    return result;
}

@end

@implementation OCSWeakWrapper

+ (instancetype)weakWrapperWithObject:(id)object {
    return [[self alloc] initWithObject:object];
}

- (instancetype)initWithObject:(id)object {
    self = [super init];
    if (self) {
        self.object = object;
    }
    return self;
}

@end