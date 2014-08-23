//
//  OCSConfiguratorFromClass.m
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.



#import "OCSConfiguratorFromClass.h"
#import "OCSConfiguratorBase+ForSubclassEyesOnly.h"

#import <objc/message.h>

#import "OCSConfiguratorConstants.h"
#import "OCSApplicationContext.h"
#import "OCSDefinition.h"
#import "OCSDLogger.h"
#import "OCSObjectFactory.h"
#import "OCSScopeFactory.h"
#import "DRYRuntimeMagic.h"

#define OCS_EXTENDED_FACTORY_IVAR_KEY_GENERATOR_BLOCK "__ocs_factory_class_generatorBlock"
#define OCS_EXTENDED_FACTORY_CLASSNAME_PREFIX "OCSReliantExtended_"

/**
Configurator private category. Holds private ivars and methods.
*/
@interface OCSConfiguratorFromClass () {
    /**
    A reference to the configurator instance.
    @see OCSConfiguratorFromClass
    */
    id <OCSObjectFactory> _configInstance;
}

/**
Register aliases for a definition. Registers an upper cased alias, a "first small letter" alias and all aliases found in the factory class for this definition (through calling aliasesForXXX:).

@param definition the defintion which will receive the aliases
*/
- (void)_registerAliasesForDefinition:(OCSDefinition *)definition;


@end

typedef BOOL(^MethodFilter)(NSString *);

typedef NSString *(^KeyGenerator)(NSString *);

@interface StandinFactory : NSObject <OCSObjectFactory>

@property (nonatomic, strong) NSMutableArray *factoryCallStack;
@property (nonatomic, strong) NSMutableArray *extendedStack;
@property (nonatomic, weak) OCSApplicationContext *applicationContext;

@end


@implementation OCSConfiguratorFromClass

- (instancetype)init {
    Class factoryClass = [self _lookForConfigurationClass];
    if (factoryClass) {
        self = [self initWithClass:factoryClass];
    } else {
        self = nil;
    }
    return self;

}


- (id)initWithClass:(Class)factoryClass {
    self = [super init];
    if (self) {
        _configInstance = [self _createExtendedConfiguratorInstance:factoryClass filteringMethodsBy:^(NSString *name) {
            BOOL result = ([name hasPrefix:LAZY_SINGLETON_PREFIX] || [name hasPrefix:EAGER_SINGLETON_PREFIX]);
            return result;
        }                                        generatingKeysWith:^(NSString *name) {
            NSUInteger offset;
            if ([name hasPrefix:LAZY_SINGLETON_PREFIX]) {
                offset = LAZY_SINGLETON_PREFIX.length;
            } else {
                offset = EAGER_SINGLETON_PREFIX.length;
            }

            return [name substringFromIndex:offset];
        }];

        unsigned int count;
        Method *methods = class_copyMethodList(factoryClass, &count);
        if (count > 0) {
            for (int i = 0; i < count; i++) {
                Method method = methods[i];
                [self _investigateIfDefinitionCanBeCreatedForMethod:method];
            }
        } else {
            DLog(@"No methods found on class...");
        }
        free(methods);
    }
    return self;
}

- (void)_investigateIfDefinitionCanBeCreatedForMethod:(Method)method {
    NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method)) encoding:NSUTF8StringEncoding];
    unsigned int paramCount = method_getNumberOfArguments(method);
    if ([methodName hasPrefix:@"create"] && paramCount == 2) {
        [self _createDefinitionForMethodNamed:methodName];
    } else {
        DLog(@"Ignoring non-create method (%@)", methodName);
    }
}

- (void)_createDefinitionForMethodNamed:(NSString *)methodName {
    OCSDefinition *def = [[OCSDefinition alloc] init];
    def.scope = @"prototype";
    NSUInteger offset = 0;
    if ([methodName hasPrefix:LAZY_SINGLETON_PREFIX]) {
        def.scope = @"singleton";
        def.lazy = YES;
        offset = LAZY_SINGLETON_PREFIX.length;
    } else if ([methodName hasPrefix:EAGER_SINGLETON_PREFIX]) {
        def.scope = @"singleton";
        def.lazy = NO;
        offset = EAGER_SINGLETON_PREFIX.length;
    } else if ([methodName hasPrefix:PROTOTYPE_PREFIX]) {
        offset = PROTOTYPE_PREFIX.length;
    }

    if (offset) {
        NSString *key = [methodName substringFromIndex:offset];
        if (key.length > 0) {
            def.key = key;
            [self _registerAliasesForDefinition:def];
            DLog(@"Registering definition %@", def);
            [self registerDefinition:def];
        }
    } else {
        DLog(@"Create method found, but not as expected, ignoring it (%@)", methodName);
    }
}

- (void)_registerAliasesForDefinition:(OCSDefinition *)definition {
    NSString *key = definition.key;

    //Alias where all letters are upper cased, if equal to key, don't add!
    NSString *upperCased = [key uppercaseString];
    if (![upperCased isEqualToString:key]) {
        [definition addAlias:upperCased];
    }

    //Alias where first letter is lower case, if equal to key, don't add! Cannot be equal to upper cased alias, since first letter will always be lower case (DUH!)
    NSString *smallLetterAlias = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[key substringWithRange:NSMakeRange(0, 1)] lowercaseString]];
    if (![smallLetterAlias isEqualToString:key]) {
        [definition addAlias:smallLetterAlias];
    }

    NSString *aliasMethodName = [NSString stringWithFormat:@"%@%@", ALIAS_METHOD_PREFIX, key];
    Method aliasMethod = class_getInstanceMethod([_configInstance class], NSSelectorFromString(aliasMethodName));
    if (aliasMethod) {
        id aliases = method_invoke(_configInstance, aliasMethod);
        if (![aliases isKindOfClass:[NSArray class]]) {
            [NSException raise:@"OCSConfiguratorException" format:@"Method %@ should return an NSArray or a subclass of it", aliasMethodName];
        }

        [aliases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![obj isKindOfClass:[NSString class]]) {
                [NSException raise:@"OCSConfiguratorException" format:@"Method %@ should return an NSArray or a subclass of it, containing only NSString objects or a subclass of it", aliasMethodName];
            }

            [definition addAlias:obj];
        }];
    }
}

- (id)_createExtendedConfiguratorInstance:(Class)baseClass filteringMethodsBy:(MethodFilter)methodFilter generatingKeysWith:(KeyGenerator)keyGenerator {
    //Get the base class, we will extend this class
    char *dest = malloc(strlen(OCS_EXTENDED_FACTORY_CLASSNAME_PREFIX) + strlen(class_getName(baseClass)) + 1);
    dest = strcpy(dest, OCS_EXTENDED_FACTORY_CLASSNAME_PREFIX);
    const char *name = strcat(dest, class_getName(baseClass));
    Class extendedClass = objc_allocateClassPair(baseClass, name, sizeof(id));
    id instance = nil;
    if (extendedClass) {
        class_addProtocol(extendedClass, @protocol(OCSObjectFactory));
        class_addIvar(extendedClass, OCS_EXTENDED_FACTORY_IVAR_KEY_GENERATOR_BLOCK, sizeof(KeyGenerator), log2(sizeof(KeyGenerator)), @encode(KeyGenerator));
        objc_registerClassPair(extendedClass);

        Class standinFactoryClass = [StandinFactory class];
        Method standinCreateObjectMethod = class_getInstanceMethod(standinFactoryClass, @selector(createObjectForDefinition:));
        IMP createObjectIMP = method_getImplementation(standinCreateObjectMethod);
        class_addMethod(extendedClass, @selector(createObjectForDefinition:), createObjectIMP, method_getTypeEncoding(standinCreateObjectMethod));

        Method standinBindToContextMethod = class_getInstanceMethod(standinFactoryClass, @selector(bindToContext:));
        IMP bindToContextIMP = method_getImplementation(standinBindToContextMethod);
        class_addMethod(extendedClass, @selector(bindToContext:), bindToContextIMP, method_getTypeEncoding(standinBindToContextMethod));

        [DRYRuntimeMagic copyPropertyNamed:@"factoryCallStack" fromClass:standinFactoryClass toClass:extendedClass];
        [DRYRuntimeMagic copyPropertyNamed:@"extendedStack" fromClass:standinFactoryClass toClass:extendedClass];
        [DRYRuntimeMagic copyPropertyNamed:@"applicationContext" fromClass:standinFactoryClass toClass:extendedClass];

        unsigned int methodCount;
        Method *methods = class_copyMethodList(baseClass, &methodCount);
        Method extendedFactoryMethod = class_getInstanceMethod(standinFactoryClass, @selector(extendedFactoryMethod));
        IMP extendedFactoryMethodIMP = method_getImplementation(extendedFactoryMethod);

        //For each method wich returns an object, add an override
        for (int i = 0; i < methodCount; i++) {
            Method m = methods[i];
            char *returnType = method_copyReturnType(m);
            //Only take methods which have object as return type, no arguments and are evaluated as valid by the filter block
            if (returnType[0] == _C_ID && method_getNumberOfArguments(m) == 2 && methodFilter(NSStringFromSelector(method_getName(m)))) {
                class_addMethod(extendedClass, method_getName(m), extendedFactoryMethodIMP, method_getTypeEncoding(m));
            }
            free(returnType);
        }
        free(methods);

    } else {
        extendedClass = objc_getClass(name);
    }
    free(dest);

    instance = [[extendedClass alloc] init];
    [instance setFactoryCallStack:[NSMutableArray array]];
    Ivar keyGeneratorScopeIvar = class_getInstanceVariable(extendedClass, OCS_EXTENDED_FACTORY_IVAR_KEY_GENERATOR_BLOCK);
    object_setIvar(instance, keyGeneratorScopeIvar, keyGenerator);
    return instance;
}

- (Class)_lookForConfigurationClass {
    Class *classes = NULL;
    Class result = nil;
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        classes = (Class *) malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int index = 0; index < numClasses; index++) {
            Class nextClass = classes[index];
            NSString *name = [NSString stringWithCString:class_getName(nextClass) encoding:NSUTF8StringEncoding];
            if ([name hasSuffix:@"ReliantConfiguration"]) {
                result = nextClass;
                break;
            }
        }
        free(classes);
    }
    return result;
}

- (id <OCSObjectFactory>)objectFactory {
    return _configInstance;
}

@end



@implementation StandinFactory {
    NSMutableArray *_factoryCallStack;
}

static char factoryCallStackKey;

- (NSMutableArray *)factoryCallStack {
    return objc_getAssociatedObject(self, &factoryCallStackKey);
}

- (void)setFactoryCallStack:(NSMutableArray *)factoryCallStack {
    objc_setAssociatedObject(self, &factoryCallStackKey, factoryCallStack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char extendedStackKey;

- (NSMutableArray *)extendedStack {
    return objc_getAssociatedObject(self, &extendedStackKey);
}

- (void)setExtendedStack:(NSMutableArray *)extendedStack {
    objc_setAssociatedObject(self, &extendedStackKey, extendedStack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char applicationContextKey;

- (OCSApplicationContext *)applicationContext {
    return objc_getAssociatedObject(self, &applicationContextKey);
}

- (void)setApplicationContext:(OCSApplicationContext *) applicationContext {
    objc_setAssociatedObject(self, &applicationContextKey, applicationContext, OBJC_ASSOCIATION_ASSIGN);
}

- (id)createObjectForDefinition:(OCSDefinition *)definition {
    if ([self.factoryCallStack containsObject:definition.key]) {
        [NSException raise:@"ReliantCircularDependencyException" format:@"Circular dependency detected for the following stack: %@", [[[self.factoryCallStack reverseObjectEnumerator] allObjects] componentsJoinedByString:@" -> "]];
    }
    [self.factoryCallStack addObject:definition.key];

    id result = nil;
    if (definition) {
        NSString *methodPrefix = definition.singleton ? (definition.lazy ? LAZY_SINGLETON_PREFIX : EAGER_SINGLETON_PREFIX) : PROTOTYPE_PREFIX;
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", methodPrefix, definition.key]);
        if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            result = [self performSelector:selector];
#pragma clang diagnostic pop
        }
    }

    [self.factoryCallStack removeLastObject];
    return result;
}

- (void)bindToContext:(OCSApplicationContext *)context {
    self.applicationContext = context;
}

- (id)extendedFactoryMethod {
    NSString *selector = NSStringFromSelector(_cmd);
    struct objc_super superData;
    superData.receiver = self;
    superData.super_class = [self superclass];

    //If the method was previously called, it's result should have been cached.
    Ivar var = class_getInstanceVariable([self class], OCS_EXTENDED_FACTORY_IVAR_KEY_GENERATOR_BLOCK);
    KeyGenerator keyGenerator = object_getIvar(self, var);
    NSString *key = keyGenerator(selector);

    //If the object is already in the singleton scope, return that version, singletons never get recreated!
//    var = class_getInstanceVariable([self class], OCS_EXTENDED_FACTORY_IVAR_SINGLETON_SCOPE);
//    id<OCSScope> singletonScope = object_getIvar(self, var);
//    id result = [singletonScope objectForKey:key];
//    if (!result) {
//        result = objc_msgSendSuper(&superData, _cmd);
//        [singletonScope registerObject:result forKey:key];
//    }

    id result = nil;

    if ([self.factoryCallStack containsObject:key]) {
        if ([self.extendedStack containsObject:key]) {
            [NSException raise:@"ReliantCircularDependencyException" format:@"Circular dependency detected for the following stack: %@", [[[self.extendedStack reverseObjectEnumerator] allObjects] componentsJoinedByString:@" -> "]];
        }
        [self.extendedStack addObject:key];
        result = objc_msgSendSuper(&superData, _cmd);
        [self.extendedStack removeLastObject];
    } else {
        result = [self.applicationContext objectForKey:key];
    }
    return result;

}


@end
