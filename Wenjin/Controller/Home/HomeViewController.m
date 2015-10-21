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
#import "DetailViewController.h"
#import "TopicViewController.h"
#import "data.h"
#import "wjAppearanceManager.h"
#import "HomeCell.h"
#import "UINavigationController+JZExtension.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SearchViewController.h"
#import "TopicViewController.h"

@interface HomeViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

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
    self.navigationController.fullScreenInteractivePopGestureRecognizer = YES;
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
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    rowsData = [[NSMutableArray alloc]init];
    dataInView = [[NSMutableArray alloc]init];
    currentPage = 0;
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
    
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
    if (tmp.topicInfo.topicId == 0) {
        // 不是话题的
        NSString *actionIDString = [NSString stringWithFormat:@"%ld", (long)tmp.associateAction];
        NSDictionary *actionDiction = @{@"101": @"发布了问题",
                                        @"105": @"关注了问题",
                                        @"201": @"回答了问题",
                                        @"204": @"赞同了回答",
                                        @"501": @"发布了文章",
                                        @"502": @"赞同了文章",
                                        @"503": @"评论了文章"};
        NSString *actionString = [NSString stringWithFormat:@"%@ %@", tmp.userInfo.nickName, actionDiction[actionIDString]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:actionString];
        [str addAttribute:NSForegroundColorAttributeName value:[wjAppearanceManager userActionTextColor] range:NSMakeRange(0, [tmp.userInfo.nickName length])];
        cell.actionLabel.attributedText = str;
        [cell loadAvatarImageWithApartURL:tmp.userInfo.avatarFile];
    } else {
        // 是话题的
        NSString *actionIDString = [NSString stringWithFormat:@"%ld", (long)tmp.associateAction];
        NSDictionary *actionDiction = @{@"101": @"话题新增了问题",
                                        @"201": @"话题新增了回复",
                                        @"204": @"话题新增了回复赞同"};
        NSString *actionString = [NSString stringWithFormat:@"%@ %@", tmp.topicInfo.topicTitle, actionDiction[actionIDString]];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:actionString];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[wjAppearanceManager userActionTextColor] range:NSMakeRange(0, [tmp.topicInfo.topicTitle length])];
        cell.actionLabel.attributedText = attrStr;
        [cell loadTopicImageWithApartURL:tmp.topicInfo.topicPic];
    }
    cell.questionLabel.text = (tmp.associateAction == 501 || tmp.associateAction == 502 || tmp.associateAction == 503) ? tmp.articleInfo.title : [wjStringProcessor filterHTMLWithString:tmp.questionInfo.questionContent];
    cell.detailLabel.text = [wjStringProcessor processAnswerDetailString:tmp.answerInfo.answerContent];
    cell.actionLabel.tag = row;
    cell.questionLabel.tag = row;
    cell.detailLabel.tag = row;
    cell.avatarView.tag = row;
    cell.delegate = self;
    [cell layoutIfNeeded];
    return cell;
}

- (void)pushUserControllerWithRow:(NSUInteger)row {
    HomeCell *cell = (HomeCell *)dataInView[row];
    if (cell.topicInfo.topicId == 0) {
        // 不是话题
        if (cell.userInfo.uid != -1) {
            UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
            uVC.hidesBottomBarWhenPushed = YES;
            uVC.userId = [NSString stringWithFormat:@"%ld", (long)cell.userInfo.uid];
            [self.navigationController pushViewController:uVC animated:YES];
        } else {
            [MsgDisplay showErrorMsg:@"无法查看匿名用户~"];
        }
    } else {
        TopicViewController *topicVC = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
        topicVC.hidesBottomBarWhenPushed = YES;
        topicVC.topicId = [NSString stringWithFormat:@"%ld", (long)cell.topicInfo.topicId];
        [self.navigationController pushViewController:topicVC animated:YES];
    }
}

- (void)pushQuestionControllerWithRow:(NSUInteger)row {
    HomeCell *cell = (HomeCell *)dataInView[row];
    if (cell.associateAction == 501 || cell.associateAction == 502 || cell.associateAction == 503) {
        // 文章
        NSLog(@"%ld", (long)cell.articleInfo.aid);
        DetailViewController *aVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        aVC.detailType = DetailTypeArticle;
        aVC.answerId = [NSString stringWithFormat:@"%ld", (long)cell.articleInfo.aid];
        aVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aVC animated:YES];
    } else {
        QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
        qVC.questionId = [NSString stringWithFormat:@"%ld", (long)cell.questionInfo.questionId];
        qVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qVC animated:YES];
//        [self showViewController:qVC sender:nil];
    }
}

- (void)pushDetailControllerWithRow:(NSUInteger)row {
    DetailViewController *aVC = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    aVC.hidesBottomBarWhenPushed = YES;
    HomeCell *cell = (HomeCell *)dataInView[row];
    aVC.answerId = [NSString stringWithFormat:@"%ld", (long)cell.answerInfo.answerId];
    [self.navigationController pushViewController:aVC animated:YES];
}

#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂时无法显示内容\n\n请稍后再试";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"desperateCry"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    if ([segue.identifier isEqualToString:@"presentSearch"]) {
        SearchViewController *des = (SearchViewController *)segue.destinationViewController;
        des.searchType = 0;
    }
}


@end
