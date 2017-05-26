//
//  UserInfoCell.m
//  AutoArchiverDemo
//
//  Created by 陈彬 on 2017/5/26.
//  Copyright © 2017年 陈彬. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)setUser:(User *)user {
    _user = user;
    
    self.nameLabel.text = user.name;
    self.marriedLabel.text = user.married ? @"已婚" : @"未婚";
    self.ageLabel.text = [NSString stringWithFormat:@"%td岁", user.age];
    self.descriptionLabel.text = [NSString stringWithFormat:@"身高%0.2fm 体重%0.1fkg", user.height, user.weight];
}

@end
