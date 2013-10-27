//
//  OCSSwizzler.h
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


#import <objc/runtime.h>
#import <objc/message.h>

#import "OCSConfiguratorConstants.h"
#import "OCSScope.h"

#ifndef OCS_SWIZZLER
#define OCS_SWIZZLER

#define OCS_EXTENDED_FACTORY_IVAR_SINGLETON_SCOPE "__ocs_factory_class_singletonScope"
#define OCS_EXTENDED_FACTORY_IVAR_KEY_GENERATOR_BLOCK "__ocs_factory_class_generatorBlock"
#define OCS_EXTENDED_FACTORY_CLASSNAME_PREFIX "OCSReliantExtended_"

typedef BOOL(^MethodFilter)(NSString *);
typedef NSString *(^KeyGenerator)(NSString *);

//Extend a class, overriding all it's "createSingleton" methods which return an object and have no arguments with a dynamic one
//The dynamic methods will call the super classes implementation and store some result's so we can cahce their result.
static id createExtendedConfiguratorInstance(Class baseClass, id<OCSScope> singletonScope, MethodFilter methodFilter, KeyGenerator keyGenerator, IMP noArgIdMethodImplementation) {
    //Get the base class, we will extend this class
    char *dest = malloc(strlen(OCS_EXTENDED_FACTORY_CLASSNAME_PREFIX) + strlen(class_getName(baseClass)) + 1);
    dest = strcpy(dest, OCS_EXTENDED_FACTORY_CLASSNAME_PREFIX);
    const char *name = strcat(dest, class_getName(baseClass));
    Class extendedClass = objc_allocateClassPair(baseClass, name, sizeof(id));
    id instance = nil;
    if (extendedClass) {
        class_addIvar(extendedClass, OCS_EXTENDED_FACTORY_IVAR_SINGLETON_SCOPE, sizeof(id), log2(sizeof(id)), @encode(id));
        
        class_addIvar(extendedClass, OCS_EXTENDED_FACTORY_IVAR_KEY_GENERATOR_BLOCK, sizeof(KeyGenerator), log2(sizeof(KeyGenerator)), @encode(KeyGenerator));
        
        
        objc_registerClassPair(extendedClass);
        
        unsigned int methodCount;
        Method *methods = class_copyMethodList(baseClass, &methodCount);
        
        //For each method wich returns an object, add an override
        for (int i = 0; i < methodCount; i++) {
            Method m = methods[i];
            char *returnType = method_copyReturnType(m);
            //Only take methods which have object as return type, no arguments and are evaluated as valid by the filter block
            if (returnType[0] == _C_ID && method_getNumberOfArguments(m) == 2 && methodFilter(NSStringFromSelector(method_getName(m)))) {
                class_addMethod(extendedClass, method_getName(m), noArgIdMethodImplementation, method_getTypeEncoding(m));
            } 
            free(returnType);
        }
        free(methods);
    } else {
        extendedClass = objc_getClass(name);
    }
    free(dest);
    
    instance = [[extendedClass alloc] init];
    Ivar singletonScopeIvar = class_getInstanceVariable(extendedClass, OCS_EXTENDED_FACTORY_IVAR_SINGLETON_SCOPE);
    object_setIvar(instance, singletonScopeIvar, singletonScope);
    Ivar keyGeneratorScopeIvar = class_getInstanceVariable(extendedClass, OCS_EXTENDED_FACTORY_IVAR_KEY_GENERATOR_BLOCK);
    object_setIvar(instance, keyGeneratorScopeIvar, keyGenerator);
    return instance;
}

#endif
