//
//  TopicListTableViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/10.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "TopicListTableViewController.h"
#import "UserListTableViewCell.h"
#import "TopicDataManager.h"
#import "MsgDisplay.h"
#import "SVPullToRefresh.h"
#import "TopicViewController.h"
#import "UserDataManager.h"
#import "UserViewController.h"
#import "wjAppearanceManager.h"
#import "TopicInfo.h"
#import "JZNavigationExtension.h"
#import "SearchViewController.h"
#import "TopicViewController.h"

@interface TopicListTableViewController ()

@end

@implementation TopicListTableViewController {
    NSMutableArray *rowsData;
    NSMutableArray *dataInTable;
    NSInteger currentPage;
    NSInteger totalRows;
}

@synthesize uid;
@synthesize topicType;

- (instancetype)init {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"TopicListTableViewController"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.jz_navigationBarBackgroundHidden = NO;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        if (uid == nil) {
            // tabBar 的那个
            insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + [wjAppearanceManager pageMenuHeight];
            insets.bottom = 49;
        } else {
            insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    rowsData = [[NSMutableArray alloc]init];
    dataInTable = [[NSMutableArray alloc]init];
    currentPage = 1;
    
    __weak TopicListTableViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshContent];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf nextPage];
    }];
    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getListData {
    if (uid == nil) {
        [TopicDataManager getTopicListWithType:topicType andPage:currentPage success:^(NSUInteger _totalRows, NSArray *_rowsData) {
            
            totalRows = _totalRows;
            if (currentPage == 1) {
                rowsData = [[NSMutableArray alloc]initWithArray:_rowsData];
            } else {
                [rowsData addObjectsFromArray:_rowsData];
            }
            dataInTable = rowsData;
            
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView.pullToRefreshView stopAnimating];
            
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    } else {
        self.title = @"话题";
        [UserDataManager getFollowTopicListWithUserID:uid page:currentPage success:^(NSUInteger _totalRows, NSArray *_rowsData) {
            totalRows = _totalRows;
            if (currentPage == 1) {
                rowsData = [[NSMutableArray alloc]initWithArray:_rowsData];
            } else {
                [rowsData addObjectsFromArray:_rowsData];
            }
            dataInTable = rowsData;
            
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    

}

- (void)refreshContent {
    currentPage = 1;
    rowsData = [[NSMutableArray alloc] init];
    [self getListData];
}

- (void)nextPage {
    if ([dataInTable count] == totalRows) {
        [MsgDisplay showErrorMsg:@"已经到最后一页了哦~"];
        [self.tableView.infiniteScrollingView stopAnimating];
        return;
    }
    if ([dataInTable count] < totalRows) {
        currentPage ++;
        [self getListData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"reuseIdentifier";
    // 复用 UserListTableViewCell
    UserListTableViewCell *cell = (UserListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    TopicInfo *tmp = dataInTable[row];
    cell.userNameLabel.text = tmp.topicTitle;
    cell.userSigLabel.text = tmp.topicDescription;
    [cell loadTopicImageWithApartURL:tmp.topicPic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    TopicInfo *tmp = dataInTable[row];
    TopicViewController *topicBestAnswer = [[TopicViewController alloc]initWithNibName:@"TopicViewController" bundle:nil];
    topicBestAnswer.topicId = [NSString stringWithFormat:@"%ld", (long)tmp.topicId];
    topicBestAnswer.hidesBottomBarWhenPushed = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:topicBestAnswer animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
