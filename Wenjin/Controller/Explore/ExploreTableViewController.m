//
//  ExploreTableViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/12.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "ExploreTableViewController.h"
#import "SVPullToRefresh.h"
#import "ExploreDataManager.h"
#import "MsgDisplay.h"
#import "wjStringProcessor.h"
#import "UserViewController.h"
#import "QuestionViewController.h"

@interface ExploreTableViewController ()

@end

@implementation ExploreTableViewController {
    NSMutableArray *rowsData;
    NSMutableArray *dataInTable;
    NSInteger currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    rowsData = [[NSMutableArray alloc]init];
    dataInTable = [[NSMutableArray alloc]init];
    currentPage = 1;
    
    __weak ExploreTableViewController *weakSelf = self;
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
    [ExploreDataManager getExploreDataWithPage:currentPage isRecommended:0 sortType:@"new" success:^(BOOL isLastPage, NSArray *_rowsData) {
        
        if (!isLastPage) {
            if (currentPage == 1) {
                rowsData = [[NSMutableArray alloc]initWithArray:_rowsData];
            } else {
                [rowsData addObjectsFromArray:_rowsData];
            }
            dataInTable = rowsData;
        } else {
            [MsgDisplay showErrorMsg:@"已经到最后一页了哦~"];
            currentPage --;
        }
        
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
        
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)refreshContent {
    currentPage = 1;
    rowsData = [[NSMutableArray alloc]init];
    [self getListData];
}

- (void)nextPage {
    currentPage ++;
    [self getListData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataInTable.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSString *questionTitle = (dataInTable[row])[@"question_content"];
    NSString *detailStr = @"";
    return 56 + [self heightOfLabelWithTextString:questionTitle] + [self heightOfLabelWithTextString:detailStr];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    NSDictionary *tmp = dataInTable[row];
    cell.actionLabel.text = [NSString stringWithFormat:@"%@ 发布了问题", (tmp[@"user_info"])[@"user_name"]];
    cell.questionLabel.text = [wjStringProcessor filterHTMLWithString:tmp[@"question_content"]];
    [cell loadAvatarImageWithApartURL:(tmp[@"user_info"])[@"avatar_file"]];
    cell.detailLabel.text = @"";
    cell.actionLabel.tag = row;
    cell.questionLabel.tag = row;
    cell.avatarView.tag = row;
    cell.delegate = self;
    return cell;
}

- (CGFloat)heightOfLabelWithTextString:(NSString *)textString {
    CGFloat width = self.tableView.frame.size.width - 32;
    
    UILabel *gettingSizeLabel = [[UILabel alloc]init];
    gettingSizeLabel.text = textString;
    gettingSizeLabel.font = [UIFont systemFontOfSize:17];
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maxSize = CGSizeMake(width, 1000.0);
    
    CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
    return size.height;
}

// Cell Delegate

- (void)pushUserControllerWithRow:(NSUInteger)row {
    UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    uVC.hidesBottomBarWhenPushed = YES;
    uVC.userId = [((dataInTable[row])[@"user_info"])[@"uid"] stringValue];
    [self.navigationController pushViewController:uVC animated:YES];
}

- (void)pushQuestionControllerWithRow:(NSUInteger)row {
    QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
    qVC.questionId = [(dataInTable[row])[@"question_id"] stringValue];
    qVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qVC animated:YES];
}

- (void)pushAnswerControllerWithRow:(NSUInteger)row {
    
}


@end
