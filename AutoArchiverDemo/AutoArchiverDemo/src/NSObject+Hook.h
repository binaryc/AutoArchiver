//
//  NSObject+Hook.h
//  BNCFoundation
//
//  Created by 陈彬 on 2017/5/26.
//  Copyright © 2017年 陈彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Hook)

+ (BOOL)addMethod:(SEL)methodSEL implement:(SEL)implementSEL;
+ (void)swizzleInstanceMethodSEL:(SEL)originalSEL swizzledMethodSEL:(SEL)swizzledSEL;

@end
