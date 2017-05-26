//
//  User.h
//  AutoArchiverDemo
//
//  Created by 陈彬 on 2017/5/26.
//  Copyright © 2017年 陈彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) int userID;
@property (nonatomic, assign) BOOL married;
@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) float height;
@property (nonatomic, assign) double weight;

@property (nonatomic, strong) NSString *name;

@end
