//
//  HomeViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/28.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeDataManager.h"
#import "MsgDisplay.h"
#import "SVPullToRefresh.h"
#import "wjAccountManager.h"
#import "wjStringProcessor.h"
#import "UserViewController.h"
#import "QuestionViewController.h"
#import "AnswerViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {
    NSMutableArray *rowsData;
    NSMutableArray *dataInView;
    NSInteger currentPage;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.allowsSelection = NO;
    
    //修复下拉刷新位置错误
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
    
    __weak HomeViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshContent];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf nextPage];
    }];
    
    if ([wjAccountManager userIsLoggedIn]) {
        [self.tableView triggerPullToRefresh];
    }
}

- (void)getListData {
    [HomeDataManager getHomeDataWithPage:currentPage success:^(NSArray *_rowsData, BOOL isLastPage) {
        if (!isLastPage) {
            if (currentPage == 0) {
                rowsData = [[NSMutableArray alloc]initWithArray:_rowsData];
            } else {
                [rowsData addObjectsFromArray:_rowsData];
            }
            dataInView = rowsData;
            [self.tableView reloadData];
        } else {
            [MsgDisplay showErrorMsg:@"已经到最后一页了哦"];
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
    [self getListData];
}

- (void)refreshContent {
    currentPage = 0;
    rowsData = [[NSMutableArray alloc]init];
    [self getListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataInView count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    associate_action 代码说明
    
    101 发布问题 (history_id,associate_action,add_time,uid,user_info,associate_id,question_info)
    105 关注问题 (history_id,associate_action,add_time,uid,user_info,associate_id,question_info)
    201 回答问题 (history_id,associate_action,add_time,uid,user_info,associate_id,answer_info,question_info)
    204 赞同问题回答 (history_id,associate_action,add_time,uid,user_info,associate_id,answer_info,question_info)
    501 发布文章 (history_id,associate_action,add_time,uid,user_info,associate_id,article_info)
    502 赞同文章 (history_id,associate_action,add_time,uid,user_info,associate_id,article_info)
    */
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    NSDictionary *tmp = dataInView[row];
    NSString *actionIDString = [tmp[@"associate_action"] stringValue];
    NSDictionary *actionDiction = @{@"101": @"发布了问题",
                                    @"105": @"关注了问题",
                                    @"201": @"回答了问题",
                                    @"204": @"赞同了回答"};
    cell.actionLabel.text = [NSString stringWithFormat:@"%@ %@", (tmp[@"user_info"])[@"user_name"], actionDiction[actionIDString]];
    cell.questionLabel.text = [wjStringProcessor filterHTMLWithString:(tmp[@"question_info"])[@"question_content"]];
    cell.detailLabel.text = [wjStringProcessor processAnswerDetailString:(tmp[@"answer_info"])[@"answer_content"]];
    cell.actionLabel.tag = row;
    cell.questionLabel.tag = row;
    cell.detailLabel.tag = row;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSString *questionTitle = ((dataInView[row])[@"question_info"])[@"question_content"];
    NSString *detailStr = [wjStringProcessor processAnswerDetailString:((dataInView[row])[@"answer_info"])[@"answer_content"]];
    return 76 + [self heightOfLabelWithTextString:questionTitle] + [self heightOfLabelWithTextString:detailStr];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)heightOfLabelWithTextString:(NSString *)textString {
    CGFloat width = self.tableView.frame.size.width;
    
    UILabel *gettingSizeLabel = [[UILabel alloc]init];
    gettingSizeLabel.text = textString;
    gettingSizeLabel.font = [UIFont systemFontOfSize:15];
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maxSize = CGSizeMake(width, 1000.0);
    
    CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
    return size.height;
}

// HomeTableViewCell delegate

- (void)pushUserControllerWithRow:(NSUInteger)row {
    NSLog(@"U: %ld", row);
}

- (void)pushQuestionControllerWithRow:(NSUInteger)row {
    NSLog(@"Q: %ld", row);
    QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
    qVC.questionId = ((rowsData[row])[@"question_info"])[@"question_id"];
    qVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qVC animated:YES];
}

- (void)pushAnswerControllerWithRow:(NSUInteger)row {
    NSLog(@"A: %ld", row);
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}


@end
