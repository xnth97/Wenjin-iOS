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
#import "data.h"
#import "wjAppearanceManager.h"
#import "HomeCell.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {
    NSMutableArray *rowsData;
    NSMutableArray *dataInView;
    NSInteger currentPage;
}

@synthesize shouldRefresh;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    if (shouldRefresh) {
        [self.tableView triggerPullToRefresh];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.allowsSelection = NO;
    
    if ([[self.navigationController.tabBarController valueForKey:@"showNotLoggedInView"] isEqual: @NO]) {
        [self.tableView triggerPullToRefresh];
    }
    
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
    
    // iOS 8 Self Sizing Cell is fucking gooooooood!!!
    self.tableView.estimatedRowHeight = 93.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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
        
        self.shouldRefresh = NO;
        
    } failure:^(NSString *errStr) {
        if ([errStr isEqualToString:@"请先登录或注册"]) {
            [wjAccountManager logout];
            [self.tabBarController setValue:@YES forKey:@"showNotLoggedInView"];
        } else {
            [MsgDisplay showErrorMsg:errStr];
        }
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
    HomeCell *tmp = dataInView[row];
    NSString *actionIDString = [NSString stringWithFormat:@"%ld", (long)tmp.associateAction];
    NSDictionary *actionDiction = @{@"101": @"发布了问题",
                                    @"105": @"关注了问题",
                                    @"201": @"回答了问题",
                                    @"204": @"赞同了回答",
                                    @"501": @"发布了文章"};
    NSString *actionString = [NSString stringWithFormat:@"%@ %@", tmp.userInfo.nickName, actionDiction[actionIDString]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:actionString];
    [str addAttribute:NSForegroundColorAttributeName value:[wjAppearanceManager userActionTextColor] range:NSMakeRange(0, [tmp.userInfo.nickName length])];
    cell.actionLabel.attributedText = str;
    cell.questionLabel.text = (tmp.associateAction == 501) ? tmp.articleInfo.title : [wjStringProcessor filterHTMLWithString:tmp.questionInfo.questionContent];
    cell.detailLabel.text = [wjStringProcessor processAnswerDetailString:tmp.answerInfo.answerContent];
    cell.actionLabel.tag = row;
    cell.questionLabel.tag = row;
    cell.detailLabel.tag = row;
    cell.avatarView.tag = row;
    cell.delegate = self;
    [cell loadAvatarImageWithApartURL:tmp.userInfo.avatarFile];
    [cell layoutIfNeeded];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSUInteger row = [indexPath row];
//    NSString *questionTitle = ((dataInView[row])[@"question_info"])[@"question_content"];
//    NSString *detailStr = [wjStringProcessor processAnswerDetailString:((dataInView[row])[@"answer_info"])[@"answer_content"]];
//    return 56 + [self heightOfLabelWithTextString:questionTitle andFontSize:17.0] + [self heightOfLabelWithTextString:detailStr andFontSize:15.0];
//}

//- (CGFloat)heightOfLabelWithTextString:(NSString *)textString andFontSize:(CGFloat)fontSize {
//    CGFloat width = self.tableView.frame.size.width - 32;
//    
//    UILabel *gettingSizeLabel = [[UILabel alloc]init];
//    gettingSizeLabel.text = textString;
//    gettingSizeLabel.font = [UIFont systemFontOfSize:fontSize];
//    gettingSizeLabel.numberOfLines = 3;
//    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    CGSize maxSize = CGSizeMake(width, 1000.0);
//    
//    CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
//    return size.height;
//}

// HomeTableViewCell delegate

- (void)pushUserControllerWithRow:(NSUInteger)row {
    HomeCell *cell = (HomeCell *)dataInView[row];
    if (cell.userInfo.uid != -1) {
        UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        uVC.hidesBottomBarWhenPushed = YES;
        uVC.userId = [NSString stringWithFormat:@"%ld", cell.userInfo.uid];
        [self.navigationController pushViewController:uVC animated:YES];
    } else {
        [MsgDisplay showErrorMsg:@"无法查看匿名用户~"];
    }
}

- (void)pushQuestionControllerWithRow:(NSUInteger)row {
    QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
    HomeCell *cell = (HomeCell *)dataInView[row];
    if (cell.associateAction == 501) {
        // 文章
        NSLog(@"%ld", cell.articleInfo.aid);
        AnswerViewController *aVC = [[AnswerViewController alloc] initWithNibName:@"AnswerViewController" bundle:nil];
        aVC.detailType = 1;
        aVC.answerId = [NSString stringWithFormat:@"%ld", cell.articleInfo.aid];
        aVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aVC animated:YES];
    } else {
        qVC.questionId = [NSString stringWithFormat:@"%ld", cell.questionInfo.questionId];
        qVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qVC animated:YES];
    }
}

- (void)pushAnswerControllerWithRow:(NSUInteger)row {
    AnswerViewController *aVC = [[AnswerViewController alloc]initWithNibName:@"AnswerViewController" bundle:nil];
    aVC.hidesBottomBarWhenPushed = YES;
    HomeCell *cell = (HomeCell *)dataInView[row];
    aVC.answerId = [NSString stringWithFormat:@"%ld", cell.answerInfo.answerId];
    [self.navigationController pushViewController:aVC animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}


@end
