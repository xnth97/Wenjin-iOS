//
//  NotificationTableViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "NotificationTableViewController.h"
#import "SVPullToRefresh.h"
#import "NotificationManager.h"
#import "HomeTableViewCell.h"
#import "wjStringProcessor.h"
#import "UserViewController.h"
#import "QuestionViewController.h"
#import "DetailViewController.h"
#import "data.h"
#import "wjAppearanceManager.h"
#import "MsgDisplay.h"
#import "NotificationCell.h"
#import "MJExtension.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "APService.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UINavigationController+JZExtension.h"

@interface NotificationTableViewController () <homeTableViewCellDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@end

@implementation NotificationTableViewController {
    NSMutableArray *rowsData;
    NSMutableArray *dataInView;
    NSInteger currentPage;
    
    BOOL fetchingData;

    UIBarButtonItem *clearAllBtn;
}

@synthesize notificationIsReadOrNot;

- (instancetype)init {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"NotificationTableViewController"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + [wjAppearanceManager pageMenuHeight];
        insets.bottom = 49;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    rowsData = [[NSMutableArray alloc]init];
    dataInView = [[NSMutableArray alloc]init];
    currentPage = 0;
    fetchingData = NO;
    
    __weak NotificationTableViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshContent];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf nextPage];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:NOTIFICATION_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:NOTIFICATION_CLEAR_ALL object:nil];
    
    self.tableView.estimatedRowHeight = 93;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    [self.tableView triggerPullToRefresh];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods

- (void)getList {
    fetchingData = YES;
    __block BOOL currentNotificationReadMark = notificationIsReadOrNot;
    [NotificationManager getNotificationDataReadOrNot:notificationIsReadOrNot page:currentPage success:^(NSArray *_rowsData) {
        if (_rowsData.count > 0) {
            if (notificationIsReadOrNot == currentNotificationReadMark) {
                if (currentPage == 0) {
                    rowsData = [[NSMutableArray alloc] initWithArray:_rowsData];
                    dataInView = rowsData;
                    [self.tableView reloadData];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                } else {
                    [rowsData addObjectsFromArray:_rowsData];
                    dataInView = rowsData;
                    [self.tableView reloadData];
                }
            }
        } else {
            if (rowsData.count > 0 && currentPage > 1) {
                [MsgDisplay showErrorMsg:@"已经到最后一页了喔"];
            }
            currentPage --;
        }
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
        fetchingData = NO;
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
        fetchingData = NO;
    }];
}

- (void)nextPage {
    if (!fetchingData) {
        currentPage ++;
        [self getList];
    }
}

- (void)refreshContent {
    if (!fetchingData) {
        currentPage = 0;
//        [rowsData removeAllObjects];
//        [self.tableView reloadData];
        [self getList];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newNotification" object:nil];
    }
}

- (void)notificationHandler:(NSNotification *)notification {
    if ([notification.name isEqualToString:NOTIFICATION_REFRESH]) {
        [self refreshContent];
    } else if ([notification.name isEqualToString:NOTIFICATION_CLEAR_ALL]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"全部清除" message:@"是否要清除全部未读消息？" preferredStyle: UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *clearAll = [UIAlertAction actionWithTitle:@"全部清除" style: UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [NotificationManager readAllNotificationsWithCompletionBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newNotification" object:nil];
                if (notificationIsReadOrNot == NO) {
                    [self refreshContent];
                }
            }];
        }];
        [alertController addAction:cancel];
        [alertController addAction:clearAll];
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        alertController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        alertController.popoverPresentationController.barButtonItem = self.parentViewController.navigationItem.rightBarButtonItem;
        alertController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataInView.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleIdentifier";
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // 101：关注
    // 102：回复
    // 105：评论了你在问题...中的回复
    // 116：在问题回答评论中提到了你
    // 107：赞同了你
    
    NSInteger row = [indexPath row];
    NotificationCell *tmp = dataInView[row];
    NSString *actionType = [NSString stringWithFormat:@"%ld", (long)tmp.actionType];
    NSDictionary *actionDic = @{@"101": @"关注了你",
                                @"102": @"回复了问题",
                                @"104": @"邀请你回答问题",
                                @"105": @"评论了你在问题中的回复",
                                @"116": @"在问题回答评论中提到了你",
                                @"107": @"赞同了你",
                                @"108": @"感谢了你的回答",
                                @"117": @"评论了文章"};
    NSString *actionString = [NSString stringWithFormat:@"%@ %@", tmp.nickName, actionDic[actionType]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:actionString];
    [str addAttribute:NSForegroundColorAttributeName value:[wjAppearanceManager userActionTextColor] range:NSMakeRange(0, [tmp.nickName length])];
    cell.actionLabel.attributedText = str;
    cell.questionLabel.text = [wjStringProcessor filterHTMLWithString:tmp.title];
    //cell.detailLabel.text = (([actionType isEqualToString:@"102"] || [actionType isEqualToString:@"105"]) ? @"I NEED ANSWER DETAIL" : nil);
    cell.detailLabel.text = @"";
    cell.actionLabel.tag = row;
    cell.questionLabel.tag = row;
    cell.detailLabel.tag = row;
    cell.avatarView.tag = row;
    cell.delegate = self;
    [cell loadAvatarImageWithApartURL:tmp.avatar];
    cell.questionLabel.preferredMaxLayoutWidth = CGRectGetWidth(cell.questionLabel.frame);
    //[cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NotificationCell *tmp = dataInView[row];
    if (tmp.actionType == 101) {
        return 52;
    } else {
        return UITableViewAutomaticDimension;
    }
}

#pragma mark - HomeTableViewCellDelegate

- (void)pushUserControllerWithRow:(NSUInteger)row {
    NotificationCell *tmp = dataInView[row];
    if (tmp.uid != -1) {
        UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        uVC.hidesBottomBarWhenPushed = YES;
        uVC.userId = [NSString stringWithFormat:@"%ld", (long)tmp.uid];
        [self.navigationController pushViewController:uVC animated:YES];
        if (tmp.actionType == 101 || tmp.actionType == 107) {
            if (notificationIsReadOrNot == NO) {
                [NotificationManager readNotificationWithNotificationID:tmp.notificationId];
                [dataInView removeObjectAtIndex:row];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView reloadData];
            }
        }
    } else {
        [MsgDisplay showErrorMsg:@"无法查看匿名用户~"];
    }
}

- (void)pushQuestionControllerWithRow:(NSUInteger)row {
    NotificationCell *tmp = dataInView[row];
    if (tmp.actionType == 104) {
        // 被邀请
        QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
        qVC.questionId = [NSString stringWithFormat:@"%ld", (long)tmp.related.questionId];
        qVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qVC animated:YES];
        if (notificationIsReadOrNot == NO) {
            [NotificationManager readNotificationWithNotificationID:tmp.notificationId];
            [dataInView removeObjectAtIndex:row];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadData];
        }
    } else if (tmp.actionType == 117) {
        // 评论了文章
        DetailViewController *aVC = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
        aVC.hidesBottomBarWhenPushed = YES;
        aVC.detailType = DetailTypeArticle;
        aVC.answerId = [NSString stringWithFormat:@"%ld", (long)tmp.keyUrl];
        [self.navigationController pushViewController:aVC animated:YES];
        if (notificationIsReadOrNot == NO) {
            [NotificationManager readNotificationWithNotificationID:tmp.notificationId];
            [dataInView removeObjectAtIndex:row];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadData];
        }
    } else {
        [self pushDetailControllerWithRow:row];
    }
}

- (void)pushDetailControllerWithRow:(NSUInteger)row {
    NotificationCell *tmp = dataInView[row];
    if (tmp.related != nil) {
        DetailViewController *aVC = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
        aVC.hidesBottomBarWhenPushed = YES;
        aVC.answerId = [NSString stringWithFormat:@"%ld", (long)tmp.related.answerId];
        [self.navigationController pushViewController:aVC animated:YES];
    }
    if (notificationIsReadOrNot == NO) {
        [NotificationManager readNotificationWithNotificationID:tmp.notificationId];
        [dataInView removeObjectAtIndex:row];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = notificationIsReadOrNot ? @"暂无已读消息" : @"暂无未读消息";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"desperateSmile"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
