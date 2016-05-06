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
#import "JZNavigationExtension.h"
#import "wjAppearanceManager.h"
#import "DraftPageController.h"
#import "Chameleon.h"

#define HEADER_VIEW_HEIGHT 215

@interface UserViewController ()

@end

@implementation UserViewController {
    NSArray *cellArray;
    NSString *userName;
    NSString *userAvatar;
    
    UIView *bgView;
}

@synthesize userId;
@synthesize userTableView;
@synthesize userData;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.userTableView.dataSource = self;
    self.userTableView.delegate = self;
    
    self.jz_navigationBarBackgroundHidden = YES;
    
    cellArray = @[];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAvatar) name:@"refreshAvatar" object:nil];
    
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor flatMintColor];
    [self.view addSubview:bgView];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.userTableView.contentInset;
        insets.top = 64;
        insets.bottom = 0;
        self.userTableView.contentInset = insets;
        self.userTableView.scrollIndicatorInsets = insets;
    }
    
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if (self.navigationController.viewControllers[0] == self) {
        self.title = @"我";
        if ([data shareInstance].myUID != nil) {
            userId = [data shareInstance].myUID;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [bgView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self refreshData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.tintColor = [wjAppearanceManager mainTintColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    UserHeaderView *headerView = (UserHeaderView *)self.userTableView.tableHeaderView;
    [headerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, HEADER_VIEW_HEIGHT)];
    [headerView layoutSubviews];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation)) {
            [bgView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        } else {
            [bgView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        }
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [bgView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushSetting"] || [segue.identifier isEqualToString:@"pushProfileEdit"]) {
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
        UIViewController *des = segue.destinationViewController;
        des.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - Private Methods

- (void)refreshData {
    if (userId != nil) {
        [UserDataManager getUserDataWithID:userId success:^(UserInfo *_userData) {
            userData = _userData;
            
            UserHeaderView *headerView = [[UserHeaderView alloc]init];
            headerView.delegate = self;
            headerView.usernameLabel.text = userData.nickName;
            headerView.userSigLabel.text = userData.signature;
            NSUInteger agreeCount = userData.agreeCount;
            NSUInteger thanksCount = userData.thanksCount;
            headerView.agreeCountLabel.text = (agreeCount >= 1000) ? [NSString stringWithFormat:@"%luK", agreeCount/1000] : [NSString stringWithFormat:@"%ld", userData.agreeCount];
            headerView.thanksCountLabel.text = (thanksCount >= 1000) ? [NSString stringWithFormat:@"%luK", thanksCount/1000] : [NSString stringWithFormat:@"%ld", userData.thanksCount];
            [headerView loadAvatarImageWithApartURLString:userData.avatarFile];
            
            userName = userData.nickName;
            userAvatar = userData.avatarFile;
            
            if (userData.hasFocus == 1) {
                [headerView.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                [headerView.followButton setTitle:@"关注" forState:UIControlStateNormal];
            }
            userTableView.tableHeaderView = headerView;
            
            if ([userId integerValue] == [[data shareInstance].myUID integerValue]) {
                headerView.followButton.hidden = YES;
                cellArray = @[@[@"我的提问", @"我的回答", @"我关注的问题", @"我关注的话题"], @[@"我关注的", @"关注我的"], @[@"草稿箱"]];
                self.title = @"我";
                [data shareInstance].myInfo = @{@"nickname": userName,
                                                @"avatar": headerView.userAvatarView.image,
                                                @"signature": headerView.userSigLabel.text};
            } else {
                cellArray = @[@[@"Ta 的提问", @"Ta 的回答", @"Ta 关注的问题", @"Ta 关注的话题"], @[@"Ta 关注的", @"关注 Ta 的"]];
                self.title = userData.nickName;
            }
            
            [userTableView reloadData];
            //[userTableView.pullToRefreshView stopAnimating];
        } failure:^(NSString *errorString) {
            [MsgDisplay showErrorMsg:errorString];
            //[userTableView.pullToRefreshView stopAnimating];
        }];
    }
}

- (void)refreshAvatar {
    UserHeaderView *headerView = (UserHeaderView *)self.userTableView.tableHeaderView;
    [headerView reloadAvatarImageWithApartURLString:userAvatar];
}

#pragma mark - Table View Delegate & Data Source

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
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)userData.questionCount];
            cell.imageView.image = [UIImage imageNamed:@"tableQues"];
        } else if (row == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)userData.answerCount];
            cell.imageView.image = [UIImage imageNamed:@"tableAns"];
        } else if (row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"tableFocQue"];
        } else if (row == 3) {
            cell.imageView.image = [UIImage imageNamed:@"tableFocTop"];
        }
    } else if (section == 1) {
        if (row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)userData.friendCount];
            cell.imageView.image = [UIImage imageNamed:@"tableFocUser"];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)userData.fansCount];
            cell.imageView.image = [UIImage imageNamed:@"tableUser"];
        }
    } else if (section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"tableDraft"];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"动态";
    } else if (section == 1) {
        return @"用户";
    } else if (section == 2) {
        return @"我的";
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
    } else if (section == 2) {
        if (row == 0) {
            DraftPageController *draftTableController = [[DraftPageController alloc] init];
            draftTableController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:draftTableController animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

#pragma mark - UserHeaderViewDelegate

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

@end
