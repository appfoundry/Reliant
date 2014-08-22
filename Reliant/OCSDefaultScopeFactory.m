//
// Created by Michael Seghers on 22/08/14.
//

#import "OCSDefaultScopeFactory.h"
#import "OCSSingletonScope.h"
#import "OCSPrototypeScope.h"


@implementation OCSDefaultScopeFactory {
    NSMutableDictionary *_scopeRegistry;

    NSDictionary *_scopeNameToClassMapping;
}

- (id)init {
    self = [super init];
    if (self) {
        _scopeRegistry = [[NSMutableDictionary alloc] init];
        _scopeNameToClassMapping = @{
                @"singleton": [OCSSingletonScope class],
                @"prototype": [OCSPrototypeScope class]
        };
    }
    return self;
}


- (id<OCSScope>)scopeForName:(NSString *)name {
    if (!name) {
        return nil;
    }

    id<OCSScope> scope = _scopeRegistry[name];
    if (!scope) {
        Class scopeClass = _scopeNameToClassMapping[name];
        if (!scopeClass) {
            scopeClass = [OCSSingletonScope class];
        }
        scope = [[scopeClass alloc] init];
        _scopeRegistry[name] = scope;
    }
    return scope;
}

@end