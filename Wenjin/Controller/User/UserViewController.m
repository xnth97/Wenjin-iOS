//
//  UserViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "UserViewController.h"
#import "UserDataManager.h"
#import "MsgDisplay.h"
#import "UserHeaderView.h"

@interface UserViewController ()

@end

@implementation UserViewController {
    NSArray *cellArray;
}

@synthesize userId;
@synthesize userTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"U %@", userId);
    
    self.userTableView.dataSource = self;
    self.userTableView.delegate = self;
    
    cellArray = @[];
    
    [UserDataManager getUserDataWithID:userId success:^(NSDictionary *userData) {
        self.title = userData[@"user_name"];
        
        UserHeaderView *headerView = [[UserHeaderView alloc]init];
        headerView.usernameLabel.text = userData[@"user_name"];
        headerView.userSigLabel.text = userData[@"signature"];
        headerView.agreeCountLabel.text = userData[@"agree_count"];
        headerView.thanksCountLabel.text = userData[@"thanks_count"];
        if ([userData[@"has_focus"] isEqual:@1]) {
            [headerView.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
        } else {
            [headerView.followButton setTitle:@"关注" forState:UIControlStateNormal];
        }
        userTableView.tableHeaderView = headerView;
        
        cellArray = @[@[@"Ta 关注的", @"关注 Ta 的"], @[@"Ta 的提问", @"Ta 的回答"]];
        [userTableView reloadData];
    } failure:^(NSString *errorString) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [cellArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    cell.textLabel.text = (cellArray[section])[row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"关注";
    } else if (section == 1) {
        return @"动态";
    } else {
        return @"";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
