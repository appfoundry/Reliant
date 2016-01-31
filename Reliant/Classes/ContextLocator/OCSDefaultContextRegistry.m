//
// Created by Michael Seghers on 01/09/14.
//

#import "OCSDefaultContextRegistry.h"
#import "OCSObjectContext.h"
#import "OCSBoundContextLocatorFactory.h"
#import "OCSBoundContextLocator.h"


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

- (void)registerContext:(id <OCSObjectContext>)context toBoundObject:(NSObject *)boundObject {
    NSString *contextName;

    if(boundObject) {
        // Associate context with the object it is bound to
        contextName = [NSString stringWithFormat:@"%@#%p", context.name, boundObject];
    } else {
        contextName = context.name;
    }

    _contextRegister[contextName] = [OCSWeakWrapper weakWrapperWithObject:context];
}

- (id <OCSObjectContext>)contextForName:(NSString *)name fromBoundObject:(NSObject *)boundObject {
    // Find all registry keys pertaining to the provided context name
    NSArray *keys = [_contextRegister.allKeys filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString * evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject hasPrefix:name];
    }]];

    if(keys.count > 1) {
        // More than 1 context was found for this context name
        // Attempt to deduce the most appropriate one by inspecting the bound object's hierarchy
        id<OCSBoundContextLocator> contextLocator = [OCSBoundContextLocatorFactory sharedBoundContextLocatorFactory].contextLocator;
        OCSObjectContext *candidateContext = [contextLocator locateBoundContextForObject:boundObject];
        OCSWeakWrapper *matchedContextWrapper = [_contextRegister.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(OCSWeakWrapper * evaluatedObject, NSDictionary *bindings) {
            return evaluatedObject.object == candidateContext;
        }]].firstObject;
        return matchedContextWrapper.object;
    }
    else if(keys.count == 1) {
        OCSWeakWrapper *contextWrapper = _contextRegister[[keys firstObject]];
        return contextWrapper.object;
    }
    else {
        return nil;
    }
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