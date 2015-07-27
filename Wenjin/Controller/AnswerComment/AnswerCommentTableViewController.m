//
//  AnswerCommentTableViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "AnswerCommentTableViewController.h"
#import "DetailDataManager.h"
#import "SVPullToRefresh.h"
#import "MsgDisplay.h"
#import "AnswerCommentTableViewCell.h"
#import "PostAnswerCommentViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "CommentInfo.h"
#import "UIScrollView+EmptyDataSet.h"

@interface AnswerCommentTableViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@end

@implementation AnswerCommentTableViewController {
    NSMutableArray *rowsData;
    NSUInteger currentPage;
}

@synthesize answerId;
@synthesize detailType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rowsData = [[NSMutableArray alloc]init];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.title = @"评论";
    
    currentPage = 0;
    
    UIBarButtonItem *commentBtn = [[UIBarButtonItem alloc] bk_initWithTitle:@"写评论" style:UIBarButtonItemStylePlain handler:^(id weakSender) {
        PostAnswerCommentViewController *pacVC = [[PostAnswerCommentViewController alloc]init];
        pacVC.answerId = answerId;
        pacVC.detailType = detailType;
        UINavigationController *pNav = [[UINavigationController alloc]initWithRootViewController:pacVC];
        [self presentViewController:pNav animated:YES completion:nil];
    }];
    [self.navigationItem setRightBarButtonItem:commentBtn];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    __weak AnswerCommentTableViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getRowsData];
    }];
    
    self.tableView.estimatedRowHeight = 68;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getRowsData {
    
    if (detailType == DetailTypeAnswer) {
        [DetailDataManager getAnswerCommentWithAnswerID:answerId success:^(NSArray *commentData) {
            rowsData = [[NSMutableArray alloc]initWithArray:commentData];
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView reloadData];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    } else {
        [DetailDataManager getArticleCommentWithID:answerId page:currentPage success:^(NSArray *commentData) {
            rowsData = [[NSMutableArray alloc]initWithArray:commentData];
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView reloadData];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [rowsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleCellIdentifier = @"simpleTableCellIdentifier";
    AnswerCommentTableViewCell *cell = (AnswerCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnswerCommentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    CommentInfo *tmp = rowsData[row];
    if (detailType == DetailTypeAnswer) {
        cell.usernameLabel.text = tmp.nickName;
        NSString *replyUserText = (tmp.atUid != 0) ? [NSString stringWithFormat:@"回复 %@：", tmp.atNickName] : @"";
        cell.commentLabel.text = [NSString stringWithFormat:@"%@%@", replyUserText, tmp.content];
    } else {
        cell.usernameLabel.text = tmp.artComNickName;
        NSString *replyUserText = (tmp.atUid != 0) ? [NSString stringWithFormat:@"回复 %@：", tmp.atNickName] : @"";
        cell.commentLabel.text = [NSString stringWithFormat:@"%@%@", replyUserText, tmp.artComContent];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    UIAlertController *replyAlert = [UIAlertController alertControllerWithTitle:@"评论回复" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Reply", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CommentInfo *tmp = rowsData[row];
        NSString *replyName = (detailType == DetailTypeAnswer) ? tmp.nickName : tmp.artComNickName;
        PostAnswerCommentViewController *postAC = [[PostAnswerCommentViewController alloc]init];
        postAC.answerId = answerId;
        postAC.replyText = [NSString stringWithFormat:@"@%@:", replyName];
        postAC.detailType = detailType;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:postAC] animated:YES completion:nil];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    [replyAlert addAction:cancelAction];
    [replyAlert addAction:replyAction];
    [replyAlert setModalPresentationStyle:UIModalPresentationPopover];
    [replyAlert.popoverPresentationController setPermittedArrowDirections:0];
    CGRect rect = self.view.frame;
    replyAlert.popoverPresentationController.sourceView = self.view;
    replyAlert.popoverPresentationController.sourceRect = rect;
    [self presentViewController:replyAlert animated:YES completion:nil];
}

#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无评论";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
