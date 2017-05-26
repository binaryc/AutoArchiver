//
//  UserInfoCell.h
//  AutoArchiverDemo
//
//  Created by 陈彬 on 2017/5/26.
//  Copyright © 2017年 陈彬. All rights reserved.
//

#import "User.h"
#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell

@property (weak, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *marriedLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
