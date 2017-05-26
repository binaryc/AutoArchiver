//
//  ViewController.m
//  AutoArchiverDemo
//
//  Created by 陈彬 on 2017/5/26.
//  Copyright © 2017年 陈彬. All rights reserved.
//

#import "User.h"
#import "UserInfoCell.h"
#import "ViewController.h"
#import "NSObject+Archiver.h"

static NSString *CellIdentifier = @"UserInfoCell";

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [User autoEncodingAndDecoding];
    
    self.activity.hidden = YES;
    [self.view addSubview:self.activity];
    [self.view bringSubviewToFront:self.activity];
    
    UINib *cellNib = [UINib nibWithNibName:@"UserInfoCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    
//    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
//    User *user = [[User alloc] init];
//    user.userID = 1;
//    user.age = 27;
//    user.married = YES;
//    user.height = 1.74;
//    user.weight = 120.0;
//    user.name = @"Binaryc";
//    
//    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.activity startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.users removeAllObjects];
        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@s.archiver", NSHomeDirectory(), [User class]];
        NSArray *userDatas = [NSArray arrayWithContentsOfFile:filePath];
        for (NSData *userData in userDatas) {
            User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
            [self.users addObject:user];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.activity stopAnimating];
        });
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.activity.isAnimating) {
        [self.activity stopAnimating];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)users {
    if (!_users) {
        _users = [NSMutableArray arrayWithCapacity:0];
    }
    return _users;
}

- (UIActivityIndicatorView *)activity {
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.hidesWhenStopped = YES;
    }
    return _activity;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    User *user = self.users[indexPath.row];
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.user = user;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
