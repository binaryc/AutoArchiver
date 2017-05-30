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

static NSString *didAddMethod;

@implementation NSObject (Archiver)

+ (void)autoEncodingAndDecoding {
    
    if ([objc_getAssociatedObject(self, &didAddMethod) boolValue]) {
        return;
    }
    
    if (![self conformsToProtocol:@protocol(NSCoding)]) {
        class_addProtocol([self class], @protocol(NSCoding));
    }
    
    [NSObject addMethod:@selector(initWithCoder:) implement:@selector(add_initWithCoder:)];
    [NSObject addMethod:@selector(encodeWithCoder:) implement:@selector(add_encodeWithCoder:)];
    
    objc_setAssociatedObject(self, &didAddMethod, @(YES), OBJC_ASSOCIATION_ASSIGN);
}

- (instancetype)add_initWithCoder:(NSCoder *)aDecoder {
    
    id instance = [self init];
    
    unsigned int varsCount = 0;
    Ivar *vars = class_copyIvarList([self class], &varsCount);
    for (int i = 0; i < varsCount; i++) {
        
        Ivar var = vars[i];
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(var)];
        
        if (![aDecoder containsValueForKey:varName]) {
            continue;
        }
        
        const char *varType = ivar_getTypeEncoding(var);
        
        id obj;
        if (*varType == '@') {
            obj = [aDecoder decodeObjectForKey:varName];
            object_setIvar(self, var, obj);
        } else {
            
            ptrdiff_t offset = ivar_getOffset(var);
            size_t size = 0;
            void *src = NULL;
            void *dst = (__bridge void *)instance + offset;
            
            if (*varType == 'B') {
                BOOL boolValue = [aDecoder decodeBoolForKey:varName];
                size = sizeof(boolValue);
                src = &boolValue;
            } else if (*varType == 'i') {
                int intValue = [aDecoder decodeIntForKey:varName];
                size = sizeof(intValue);
                src = &intValue;
            } else if (*varType == 'f') {
                float floatValue = [aDecoder decodeFloatForKey:varName];
                size = sizeof(floatValue);
                src = &floatValue;
            } else if (*varType == 'd') {
                double doubleValue = [aDecoder decodeDoubleForKey:varName];
                size = sizeof(doubleValue);
                src = &doubleValue;
            } else if (*varType == 'q') {
                NSInteger integerValue = [aDecoder decodeIntegerForKey:varName];
                size = sizeof(integerValue);
                src = &integerValue;
            } else if (*varType == 'Q') {
                NSUInteger uintegerValue = [aDecoder decodeIntegerForKey:varName];
                size = sizeof(uintegerValue);
                src = &uintegerValue;
            }

            memcpy(dst, src, size);
        }
    }
    
    free(vars);
    return instance;
}

- (void)add_encodeWithCoder:(NSCoder *)aCoder {
    
    unsigned int varsCount = 0;
    Ivar *vars = class_copyIvarList([self class], &varsCount);
    for (int i = 0; i < varsCount; i++) {
        Ivar var = vars[i];
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(var)];
        NSString *varType = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        
        id obj;
        if ([varType hasPrefix:@"@"]) {
            obj = object_getIvar(self, var);
            [aCoder encodeObject:obj forKey:varName];
        } else {
            
            ptrdiff_t offset = ivar_getOffset(var);
            unsigned char *stuffBytes = (unsigned char *)(__bridge void *)self;
            
            if ([varType isEqualToString:@"B"]) {
                BOOL boolValue = *((BOOL *)(stuffBytes + offset));
                [aCoder encodeBool:boolValue forKey:varName];
            } else if ([varType isEqualToString:@"i"]) {
                int intValue = *((int *)(stuffBytes + offset));
                [aCoder encodeInt:intValue forKey:varName];
            } else if ([varType isEqualToString:@"f"]) {
                float floatValue = *((float *)(stuffBytes + offset));
                [aCoder encodeFloat:floatValue forKey:varName];
            } else if ([varType isEqualToString:@"d"]) {
                double doubleValue = *((double *)(stuffBytes + offset));
                [aCoder encodeDouble:doubleValue forKey:varName];
            } else if ([varType isEqualToString:@"q"]) {
                NSInteger integerValue = *((NSInteger *)(stuffBytes + offset));
                [aCoder encodeInteger:integerValue forKey:varName];
            } else if ([varType isEqualToString:@"Q"]) {
                NSUInteger uintegerValue = *((NSUInteger *)(stuffBytes + offset));
                [aCoder encodeInteger:uintegerValue forKey:varName];
            }
        }
    }
    
    free(vars);
}

@end
