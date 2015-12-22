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

- (void)registerContext:(id <OCSObjectContext>)context  {
    [self registerContext:context toBoundObject:nil];
}

- (void)registerContext:(id <OCSObjectContext>)context toBoundObject:(NSObject *)boundObject {
    NSString *contextName;

    if(boundObject){
        contextName = [NSString stringWithFormat:@"%@#%p", context.name, boundObject];
    } else {
        contextName = context.name;
    }

    _contextRegister[contextName] = [OCSWeakWrapper weakWrapperWithObject:context];
}

- (id <OCSObjectContext>)contextForName:(NSString *)name {
    NSArray *keys = [_contextRegister.allKeys filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString * evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject hasPrefix:name];
    }]];

    NSString *contextName = [keys firstObject];
    if(contextName){
        OCSWeakWrapper *weakRef = _contextRegister[contextName];
        id<OCSObjectContext> result = nil;
        if (weakRef) {
            result = [weakRef object];
            if (!result) {
                [_contextRegister removeObjectForKey:name];
            }
        }
        return result;
    }
    return nil;
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