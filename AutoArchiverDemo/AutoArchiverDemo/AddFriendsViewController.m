//
//  AddFriendsViewController.m
//  AutoArchiverDemo
//
//  Created by 陈彬 on 2017/5/26.
//  Copyright © 2017年 陈彬. All rights reserved.
//

#import "User.h"
#import "UserInfoInputCell.h"
#import "AddFriendsViewController.h"

static NSString *UserInfoInputCellIdentifier = @"UserInfoInputCell";
static NSString *UserMarriedSituationCellIdentifier = @"UITableViewCell";

@interface AddFriendsViewController ()

@property (nonatomic, strong) User *user;

@property (nonatomic, readonly) NSArray *sections;
@property (nonatomic, strong) NSArray *firstSectionCells;
@property (nonatomic, strong) NSArray *secondSectionCells;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"UserInfoInputCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:UserInfoInputCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UserMarriedSituationCellIdentifier];
    
    self.activity.hidden = YES;
    [self.view addSubview:self.activity];
    [self.view bringSubviewToFront:self.activity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIActivityIndicatorView *)activity {
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.hidesWhenStopped = YES;
    }
    return _activity;
}

- (IBAction)doneItemPressed:(id)sender {
    
    [self.activity startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@s.archiver", NSHomeDirectory(), [User class]];
        NSArray *datas = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *userDatas = [NSMutableArray array];
        [userDatas addObjectsFromArray:datas];
        
        User *user = [[User alloc] init];
        user.userID = (int)userDatas.count + 1;
        
        UserInfoInputCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        user.name = cell.inputTextField.text;
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        user.age = cell.inputTextField.text.integerValue;
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        user.height = cell.inputTextField.text.floatValue;
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        user.weight = cell.inputTextField.text.doubleValue;

        user.married = self.tableView.indexPathForSelectedRow.row && self.tableView.indexPathForSelectedRow.section == 1;
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
        [userDatas addObject:data];
        [userDatas writeToFile:filePath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (NSArray *)firstSectionCells {
    if (!_firstSectionCells) {
        _firstSectionCells = @[@"姓名:", @"年龄:", @"身高:", @"体重:"];
    }
    return _firstSectionCells;
}

- (NSArray *)secondSectionCells {
    if (!_secondSectionCells) {
        _secondSectionCells = @[@"未婚", @"已婚"];
    }
    return _secondSectionCells;
}

- (NSArray *)sections {
    return @[self.firstSectionCells, self.secondSectionCells];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = self.sections[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *text = self.sections[indexPath.section][indexPath.row];
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        UserInfoInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:UserInfoInputCellIdentifier];
        inputCell.nameLabel.text = text;
        cell = inputCell;
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:UserMarriedSituationCellIdentifier];
        cell.textLabel.text = text;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    
    for (int i = 0; i < self.secondSectionCells.count; i++) {
        
        if (i == indexPath.row) {
            continue;
        }
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:index];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
