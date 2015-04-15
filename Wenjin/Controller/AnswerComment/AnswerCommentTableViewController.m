//
//  AnswerCommentTableViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "AnswerCommentTableViewController.h"
#import "AnswerDataManager.h"
#import "SVPullToRefresh.h"
#import "MsgDisplay.h"
#import "AnswerCommentTableViewCell.h"
#import "PostAnswerCommentViewController.h"
#import "ALActionBlocks.h"

@interface AnswerCommentTableViewController ()

@end

@implementation AnswerCommentTableViewController {
    NSMutableArray *rowsData;
}

@synthesize answerId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rowsData = [[NSMutableArray alloc]init];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.title = @"评论";
    
    UIBarButtonItem *commentBtn = [[UIBarButtonItem alloc]initWithTitle:@"写评论" style:UIBarButtonItemStylePlain block:^(id weakSender) {
        PostAnswerCommentViewController *pacVC = [[PostAnswerCommentViewController alloc]init];
        pacVC.answerId = answerId;
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
    for (UIView *tmpView in self.view.subviews) {
        if ([tmpView isKindOfClass:[UILabel class]]) {
            [tmpView removeFromSuperview];
        }
    }
    
    [AnswerDataManager getAnswerCommentWithAnswerID:answerId success:^(NSArray *commentData) {
        rowsData = [[NSMutableArray alloc]initWithArray:commentData];
        if ([rowsData count] > 0) {
            [self.tableView reloadData];
        } else {
            [self.tableView reloadData];
            UILabel *noCLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 120) / 2, (self.view.frame.size.height - 20 ) / 2 - 44, 120, 20)];
            noCLabel.text = @"暂无评论";
            noCLabel.font = [UIFont systemFontOfSize:20];
            noCLabel.textColor = [UIColor darkGrayColor];
            noCLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:noCLabel];
        }
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [rowsData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSDictionary *tmp = rowsData[row];
    NSString *replyUserText = (tmp[@"at_user"] != nil) ? [NSString stringWithFormat:@"回复 %@：", (tmp[@"at_user"])[@"nick_name"]] : @"";
    NSString *commentText = [NSString stringWithFormat:@"%@%@", replyUserText, tmp[@"content"]];
    return 40 + [self heightOfLabelWithTextString:commentText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleCellIdentifier = @"simpleTableCellIdentifier";
    AnswerCommentTableViewCell *cell = (AnswerCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnswerCommentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    NSDictionary *tmp = rowsData[row];
    cell.usernameLabel.text = tmp[@"nick_name"];
    NSString *replyUserText = (tmp[@"at_user"] != nil) ? [NSString stringWithFormat:@"回复 %@：", (tmp[@"at_user"])[@"nick_name"]] : @"";
    cell.commentLabel.text = [NSString stringWithFormat:@"%@%@", replyUserText, tmp[@"content"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    UIAlertController *replyAlert = [UIAlertController alertControllerWithTitle:@"评论回复" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Reply", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString *replyName = (rowsData[row])[@"nick_name"];
        
        PostAnswerCommentViewController *postAC = [[PostAnswerCommentViewController alloc]init];
        postAC.answerId = answerId;
        postAC.replyText = [NSString stringWithFormat:@"@%@:", replyName];
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:postAC] animated:YES completion:nil];
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

- (CGFloat)heightOfLabelWithTextString:(NSString *)textString {
    CGFloat width = self.tableView.frame.size.width - 32;
    
    UILabel *gettingSizeLabel = [[UILabel alloc]init];
    gettingSizeLabel.text = textString;
    gettingSizeLabel.font = [UIFont systemFontOfSize:15];
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maxSize = CGSizeMake(width, 1000.0);
    
    CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
    return size.height;
}

@end
