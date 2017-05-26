//
//  NSObject+Hook.m
//  BNCFoundation
//
//  Created by 陈彬 on 2017/5/26.
//  Copyright © 2017年 陈彬. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Hook.h"

@implementation NSObject (Hook)

+ (BOOL)addMethod:(SEL)methodSEL implement:(SEL)implementSEL {
    
    Method implementMethod = class_getClassMethod([self class], implementSEL);
    BOOL didAddMethod = class_addMethod([self class], methodSEL, method_getImplementation(implementMethod), method_getTypeEncoding(implementMethod));
    return didAddMethod;
}

+ (void)swizzleInstanceMethodSEL:(SEL)originalSEL swizzledMethodSEL:(SEL)swizzledSEL {
    
    Method originalMethod = class_getClassMethod([self class], originalSEL);
    Method swizzledMethod = class_getClassMethod([self class], swizzledSEL);
    
    BOOL didAddMethod = class_addMethod([self class], originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        
        class_replaceMethod([self class], swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        
    } else {
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end
