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
#import "data.h"
#import "wjCacheManager.h"
#import "SVPullToRefresh.h"
#import "wjOperationManager.h"
#import "UserListTableViewController.h"
#import "UserFeedTableViewController.h"
#import "TopicListTableViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController {
    NSArray *cellArray;
    NSString *userName;
    NSString *userAvatar;
}

@synthesize userId;
@synthesize userTableView;
@synthesize userData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.view.backgroundColor = [UIColor whiteColor];

    self.userTableView.dataSource = self;
    self.userTableView.delegate = self;
    
    cellArray = @[];
    
    /*
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.userTableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.userTableView.contentInset = insets;
        self.userTableView.scrollIndicatorInsets = insets;
    }
    
    __weak UserViewController *weakSelf = self;
    [self.userTableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    
    [self.userTableView triggerPullToRefresh];
    */
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers[0] == self) {
        self.title = @"我";
        if ([data shareInstance].myUID != nil) {
            userId = [data shareInstance].myUID;
        }
    }
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    if (userId != nil) {
        [UserDataManager getUserDataWithID:userId success:^(NSDictionary *_userData) {
            userData = _userData;
            
            UserHeaderView *headerView = [[UserHeaderView alloc]init];
            headerView.delegate = self;
            headerView.usernameLabel.text = userData[@"nick_name"];
            headerView.userSigLabel.text = (userData[@"signature"] == [NSNull null]) ? @"" : userData[@"signature"];
            NSUInteger agreeCount = [userData[@"agree_count"] integerValue];
            NSUInteger thanksCount = [userData[@"thanks_count"] integerValue];
            headerView.agreeCountLabel.text = (agreeCount >= 1000) ? [NSString stringWithFormat:@"%ldK", agreeCount/1000] : [userData[@"agree_count"] stringValue];
            headerView.thanksCountLabel.text = (thanksCount >= 1000) ? [NSString stringWithFormat:@"%ldK", thanksCount/1000] : [userData[@"thanks_count"] stringValue];
            [headerView loadAvatarImageWithApartURLString:userData[@"avatar_file"]];
            
            userName = userData[@"nick_name"];
            userAvatar = userData[@"avatar_file"];
            
            if ([userData[@"has_focus"] isEqual:@1]) {
                [headerView.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                [headerView.followButton setTitle:@"关注" forState:UIControlStateNormal];
            }
            userTableView.tableHeaderView = headerView;
            
            if ([userId integerValue] == [[data shareInstance].myUID integerValue]) {
                headerView.followButton.hidden = YES;
                cellArray = @[@[@"我的提问", @"我的回答", @"我关注的问题", @"我关注的话题"], @[@"我关注的", @"关注我的"]];
                self.title = @"我";
            } else {
                cellArray = @[@[@"Ta 的提问", @"Ta 的回答", @"Ta 关注的问题", @"Ta 关注的话题"], @[@"Ta 关注的", @"关注 Ta 的"]];
                self.title = userData[@"nick_name"];
            }
            
            [userTableView reloadData];
            //[userTableView.pullToRefreshView stopAnimating];
        } failure:^(NSString *errorString) {
            [MsgDisplay showErrorMsg:errorString];
            //[userTableView.pullToRefreshView stopAnimating];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [cellArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = (cellArray[section])[row];
    if (section == 0) {
        if (row == 0) {
            cell.detailTextLabel.text = [userData[@"question_count"] stringValue];
        } else if (row == 1) {
            cell.detailTextLabel.text = [userData[@"answer_count"] stringValue];
        }
    } else if (section == 1) {
        if (row == 0) {
            cell.detailTextLabel.text = [userData[@"friend_count"] stringValue];
        } else {
            cell.detailTextLabel.text = [userData[@"fans_count"] stringValue];
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"动态";
    } else if (section == 1) {
        return @"用户";
    } else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    if (section == 0) {
        if (row != 3) {
            UserFeedTableViewController *userFeed = [[UserFeedTableViewController alloc]initWithStyle:UITableViewStylePlain];
            userFeed.feedType = row;
            userFeed.userId = userId;
            userFeed.userName = userName;
            userFeed.userAvatar = userAvatar;
            userFeed.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userFeed animated:YES];
        } else if (row == 3) {
            TopicListTableViewController *userTopic = [[TopicListTableViewController alloc]initWithStyle:UITableViewStylePlain];
            userTopic.uid = userId;
            userTopic.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userTopic animated:YES];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (section == 1) {
        UserListTableViewController *userList = [[UserListTableViewController alloc]initWithStyle:UITableViewStylePlain];
        userList.userType = row;
        userList.userId = userId;
        userList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userList animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

// UserHeaderViewDelegate

- (void)followUser {
    [wjOperationManager followPeopleWithUserID:userId success:^(NSString *operationType) {
        
        UserHeaderView *headerView = (UserHeaderView *)self.userTableView.tableHeaderView;
        
        if ([operationType isEqualToString:@"add"]) {
            [headerView.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
        } else if ([operationType isEqualToString:@"remove"]) {
            [headerView.followButton setTitle:@"关注" forState:UIControlStateNormal];
        }
        
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
    }];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushSetting"] || [segue.identifier isEqualToString:@"pushProfileEdit"]) {
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
        UIViewController *des = segue.destinationViewController;
        des.hidesBottomBarWhenPushed = YES;
    }
}


@end
