//
//  OCSSwizzler.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 Oak Consultancy Services. All rights reserved.
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

#ifndef OCS_SWIZZLER
#define OCS_SWIZZLER

#define OCS_CACHE_IVAR "__ocs_object_cache"

//C function to swizzle, taken from http://cocoadev.com/wiki/MethodSwizzling
static void Swizzle(Class c, SEL original, Class o, SEL replacement) {
    Method origMethod = class_getInstanceMethod(c, original);
    Method newMethod = class_getInstanceMethod(o, replacement);
    if(class_addMethod(c, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, replacement, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}


//Fully dynamic method for swizzle replacement, uber awesomeness ;-)
static id dynamicIDMethodIMP(id self, SEL _cmd) {
    NSString *selector = NSStringFromSelector(_cmd); 
    struct objc_super superData;
    superData.receiver = self;
    superData.super_class = [self superclass];//[metaclass superclass];    
    
    //If the method was previously called, it's result should have been cached.
    Ivar var = class_getInstanceVariable([self class], OCS_CACHE_IVAR);
    NSMutableDictionary *cache = object_getIvar(self, var);
    id result = [cache objectForKey:selector];
    if (!result) {
        result = objc_msgSendSuper(&superData, _cmd);
        [cache setObject:result forKey:selector];
    }
    
    return result;
}

static void dynamicDealloc(id self, SEL _cmd) {
    Ivar var = class_getInstanceVariable([self class], OCS_CACHE_IVAR);
    NSMutableDictionary *cache = object_getIvar(self, var);
    [cache release];
    
    //Call super dealloc
    struct objc_super superData;
    superData.receiver = self;
    superData.super_class = [self superclass];
    
    objc_msgSendSuper(&superData, _cmd);
}




//Extend a class, overriding all it's "createSingleton" methods which return an object and have no arguments with a dynamic one
//The dynamic methods will call the super classes implementation and store some result's so we can cahce their result.
static id createExtendedConfiguratorInstance(Class baseClass, BOOL (^filter)(NSString *)) {
    //Get the base class, we will extend this class
    char *dest = malloc(strlen("OCSReliantExtended_") + strlen(class_getName(baseClass)) + 1);
    dest = strcpy(dest, "OCSReliantExtended_");
    const char *name = strcat(dest, class_getName(baseClass));
    Class extendedClass = objc_allocateClassPair(baseClass, name, sizeof(id));
    if (extendedClass) {
        class_addIvar(extendedClass, OCS_CACHE_IVAR, sizeof(NSMutableDictionary *), log2(sizeof(NSMutableDictionary*)), @encode(NSMutableDictionary *));
        
        objc_registerClassPair(extendedClass);
        
        unsigned int methodCount;
        Method *methods = class_copyMethodList(baseClass, &methodCount);
        
        //For each method wich returns an object, add an override
        for (int i = 0; i < methodCount; i++) {
            Method m = methods[i];
            char *returnType = method_copyReturnType(m);
            //Only take methods which have object as return type, no arguments and are evaluated as valid by the filter block
            if (returnType[0] == _C_ID && method_getNumberOfArguments(m) == 2 && filter(NSStringFromSelector(method_getName(m)))) {
                class_addMethod(extendedClass, method_getName(m), (IMP) dynamicIDMethodIMP, method_getTypeEncoding(m));
            } 
            free(returnType);
        }
        
        free(methods);
        
        class_addMethod(extendedClass, @selector(dealloc), (IMP) dynamicDealloc, @encode(void));
    } else {
        extendedClass = objc_getClass(name);
    }
    
    
    
    id instance = [[extendedClass alloc] init];
    
    
    NSLog(@"Class of extended %@ with super class %@", NSStringFromClass([extendedClass class]), NSStringFromClass([instance superclass]));
    object_setInstanceVariable(instance, OCS_CACHE_IVAR, [[NSMutableDictionary alloc] init]);
    
    return instance;
}

#endif
