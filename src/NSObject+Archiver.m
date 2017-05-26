//
//  NSObject+Archiver.m
//  BNCFoundation
//
//  Created by 陈彬 on 2017/5/26.
//  Copyright © 2017年 陈彬. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Hook.h"
#import "NSObject+Archiver.h"

static BOOL _didAddMethod;

@implementation NSObject (Archiver)

+ (void)autoEncodingAndDecoding {
    
    if (_didAddMethod || ![self conformsToProtocol:@protocol(NSCoding)]) {
        return;
    }
    
    [NSObject addMethod:@selector(initWithCoder:) implement:@selector(add_initWithCoder:)];
    [NSObject addMethod:@selector(encodeWithCoder:) implement:@selector(add_encodeWithCoder:)];
}

- (instancetype)add_initWithCoder:(NSCoder *)aDecoder {
    id instance = [self init];
    
    unsigned int varsCount = 0;
    Ivar *vars = class_copyIvarList([self class], &varsCount);
    for (int i = 0; i < varsCount; i++) {
        
        Ivar var = vars[i];
        const char *varName = ivar_getName(var);
        NSString *key = [NSString stringWithUTF8String:varName];
        
        if ([aDecoder containsValueForKey:key]) {
            id obj = [aDecoder decodeObjectForKey:key];
            object_setIvar(instance, var, obj);
        }
    }
    
    return instance;
}

- (void)add_encodeWithCoder:(NSCoder *)aCoder {
    unsigned int varsCount = 0;
    Ivar *vars = class_copyIvarList([self class], &varsCount);
    for (int i = 0; i < varsCount; i++) {
        Ivar var = vars[i];
        const char *varName = ivar_getName(var);
        id obj = object_getIvar(self, var);
        [aCoder encodeObject:obj forKey:[NSString stringWithUTF8String:varName]];
    }
}

@end
