//
//  AddFriendsViewController.h
//  AutoArchiverDemo
//
//  Created by 陈彬 on 2017/5/26.
//  Copyright © 2017年 陈彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
