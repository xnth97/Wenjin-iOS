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
#import "AnswerViewController.h"
#import "data.h"
#import "wjAppearanceManager.h"
#import "MsgDisplay.h"

@interface NotificationTableViewController () <homeTableViewCellDelegate>

@end

@implementation NotificationTableViewController {
    NSMutableArray *rowsData;
    NSMutableArray *dataInView;
    NSInteger currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = NO;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    rowsData = [[NSMutableArray alloc]init];
    dataInView = [[NSMutableArray alloc]init];
    currentPage = 0;
    
    __weak NotificationTableViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshContent];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf nextPage];
    }];
    
    self.tableView.estimatedRowHeight = 93.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView triggerPullToRefresh];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getList {
    [NotificationManager getNotificationDataReadOrNot:NO page:currentPage success:^(NSArray *_rowsData) {
        if (_rowsData.count > 0) {
            if (currentPage == 0) {
                rowsData = [[NSMutableArray alloc] initWithArray:_rowsData];
            } else {
                [rowsData addObjectsFromArray:_rowsData];
            }
            dataInView = rowsData;
            [self.tableView reloadData];
        } else {
            [MsgDisplay showErrorMsg:@"已经到最后一页了喔"];
            currentPage --;
        }
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)nextPage {
    currentPage ++;
    [self getList];
}

- (void)refreshContent {
    currentPage = 0;
    rowsData = [[NSMutableArray alloc] init];
    [self getList];
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
    // 106：在问题回答评论中提到了你
    // 107：赞同了你
    
    NSInteger row = [indexPath row];
    NSDictionary *tmp = dataInView[row];
    NSString *actionType = [tmp[@"action_type"] stringValue];
    NSDictionary *actionDic = @{@"101": @"关注了你",
                                @"102": @"回复了问题",
                                @"105": @"评论了你在问题中的回复",
                                @"106": @"在问题回答评论中提到了你",
                                @"107": @"赞同了你"};
    NSString *actionString = [NSString stringWithFormat:@"%@ %@", tmp[@"nick_name"], actionDic[actionType]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:actionString];
    [str addAttribute:NSForegroundColorAttributeName value:[wjAppearanceManager userActionTextColor] range:NSMakeRange(0, [tmp[@"nick_name"] length])];
    cell.actionLabel.attributedText = str;
    cell.questionLabel.text = [wjStringProcessor filterHTMLWithString:tmp[@"title"]];
    cell.detailLabel.text = (([actionType isEqualToString:@"102"] || [actionType isEqualToString:@"105"]) ? @"I NEED ANSWER DETAIL" : nil);
    cell.actionLabel.tag = row;
    cell.questionLabel.tag = row;
    cell.detailLabel.tag = row;
    cell.avatarView.tag = row;
    cell.delegate = self;
    [cell loadAvatarImageWithApartURL:tmp[@"avatar"]];
    return cell;
}

#pragma mark - HomeTableViewCellDelegate

- (void)pushUserControllerWithRow:(NSUInteger)row {
    if (!([(dataInView[row])[@"uid"] integerValue] == -1)) {
        UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        uVC.hidesBottomBarWhenPushed = YES;
        uVC.userId = [(dataInView[row])[@"uid"] stringValue];
        [self.navigationController pushViewController:uVC animated:YES];
    } else {
        [MsgDisplay showErrorMsg:@"无法查看匿名用户~"];
    }
}

- (void)pushQuestionControllerWithRow:(NSUInteger)row {
    NSDictionary *tmp = (NSDictionary *)dataInView[row];
    if (tmp[@"related"] != nil) {
        QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
        qVC.questionId = [(tmp[@"related"])[@"question_id"] stringValue];
        qVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qVC animated:YES];
    }
}

- (void)pushAnswerControllerWithRow:(NSUInteger)row {
    NSDictionary *tmp = (NSDictionary *)dataInView[row];
    if (tmp[@"related"] != nil) {
        AnswerViewController *aVC = [[AnswerViewController alloc]initWithNibName:@"AnswerViewController" bundle:nil];
        aVC.hidesBottomBarWhenPushed = YES;
        aVC.answerId = [(tmp[@"related"])[@"answer_id"] stringValue];
        [self.navigationController pushViewController:aVC animated:YES];
    }
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
