//
// Created by Michael Seghers on 01/09/14.
//

#import "OCSDefaultContextRegistry.h"
#import "OCSObjectContext.h"
#import "OCSBoundContextLocatorFactory.h"
#import "OCSBoundContextLocator.h"


@interface OCSContextRegistryEntry : NSObject

@property (nonatomic, weak) id<OCSObjectContext>context;
@property (nonatomic, weak) NSObject *boundObject;

- (instancetype)initWithContext:(id<OCSObjectContext>)context forBoundObject:(NSObject *)boundObject;

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

- (void)registerContext:(id <OCSObjectContext>)context toBoundObject:(NSObject *)boundObject {
    NSString *contextName = context.name;
    NSMutableArray *entries = _contextRegister[contextName];
    if (!entries) {
        entries = [[NSMutableArray alloc] init];
        _contextRegister[contextName] = entries;
    }
    OCSContextRegistryEntry *entry = nil;
    for (OCSContextRegistryEntry *e in entries) {
        if (e.boundObject == boundObject) {
            entry = e;
            break;
        }
    }
    
    if (entry == nil) {
        entry = [[OCSContextRegistryEntry alloc] init];
        entry.boundObject = boundObject;
        [entries addObject:entry];
    }
    entry.context = context;
}

- (id <OCSObjectContext>)contextForName:(NSString *)name fromBoundObject:(NSObject *)boundObject {
    id<OCSBoundContextLocator> contextLocator = [OCSBoundContextLocatorFactory sharedBoundContextLocatorFactory].contextLocator;
    id<OCSObjectContext> locatedContext = [contextLocator locateBoundContextForObject:boundObject];
    if (locatedContext == nil) {
        return  [self _findContextForNameInRegistry:name];
    } else if ([locatedContext.name isEqualToString:name]) {
        return locatedContext;
    } else {
        //Look for located context in register
        NSArray *entries = _contextRegister[locatedContext.parentContext.name];
        OCSContextRegistryEntry *entry = [entries filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(OCSContextRegistryEntry *_Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return evaluatedObject.context == locatedContext.parentContext;
        }]].firstObject;
        if (entry && entry.boundObject != boundObject) {
            return [self contextForName:name fromBoundObject:entry.boundObject];
        } else {
            return [self _findContextForNameInRegistry:name];
        }
    }
}

- (id<OCSObjectContext>)_findContextForNameInRegistry:(NSString *)name {
    [self _cleanNullifiedWeakContextReferences];
    NSMutableArray *entries = _contextRegister[name];
    if (entries.count > 1) {
        return nil;
    } else {
        OCSContextRegistryEntry *entry = entries.firstObject;
        return entry.context;
    }
}

- (void)_cleanNullifiedWeakContextReferences {
    for (NSString *key in _contextRegister.allKeys) {
        NSMutableArray *entries = _contextRegister[key];
        for (int i = (int)entries.count - 1; i > -1; i--) {
            OCSContextRegistryEntry *entry = entries[i];
            if (entry.context == nil) {
                [entries removeObject:entry];
            }
        }
    }
}

@end

@implementation OCSContextRegistryEntry

- (instancetype)initWithContext:(id<OCSObjectContext>)context forBoundObject:(NSObject *)boundObject {
    self = [super init];
    if (self) {
        self.context = context;
        self.boundObject = boundObject;
    }
    return self;
}

@end