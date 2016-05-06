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
#import "DetailViewController.h"
#import "wjAppearanceManager.h"
#import "ExploreCell.h"
#import "AnswerInfo.h"
#import "UINavigationController+JZExtension.h"

@interface ExploreTableViewController ()

@end

@implementation ExploreTableViewController {
    NSMutableArray *rowsData;
    NSMutableArray *dataInTable;
    NSInteger currentPage;
    
    NSInteger isRecommended;
}

@synthesize expType;

- (instancetype)init {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"ExploreTableViewController"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
//    expType = @"new";
    if (expType.length == 0) {
        isRecommended = 1;
    } else {
        isRecommended = 0;
    }
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + [wjAppearanceManager pageMenuHeight];
        insets.bottom = 49;
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
    
    self.tableView.estimatedRowHeight = 93;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getListData {
    /*
     per_page (int) 可选，默认10
     page (int) 可选，默认1
     day (int) 可选，默认30
     is_recommend (int) 可选，有1和0两种值，默认0 [如果你是要返回“推荐”栏目的数据，这个参数值设为1，sort_type可以不设]
     sort_type （string） 可选，有new，hot，unresponsive三种值，默认new new：最新 hot：热门 unresponsive：等待回复
    */
    [ExploreDataManager getExploreDataWithPage:currentPage isRecommended:isRecommended sortType:expType success:^(BOOL isLastPage, NSArray *_rowsData) {
        
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
        
        if (currentPage == 1) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self.tableView reloadData];
        }
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSUInteger row = [indexPath row];
//    NSString *questionTitle = (dataInTable[row])[@"question_content"];
//    NSString *detailStr = @"";
//    return 56 + [self heightOfLabelWithTextString:questionTitle] + [self heightOfLabelWithTextString:detailStr];
//}

#pragma warning - not completed. lack support for articles.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    ExploreCell *tmp = dataInTable[row];
    if (tmp.answerUsers.count > 0) {
        // 是回复的
        AnswerInfo *answerInfo = [tmp.answerUsers objectAtIndex:0];
        NSString *actionString = [NSString stringWithFormat:@"%@ 回答了问题", answerInfo.nickName];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:actionString];
        [str addAttribute:NSForegroundColorAttributeName value:[wjAppearanceManager userActionTextColor] range:NSMakeRange(0, [answerInfo.nickName length])];
        cell.actionLabel.attributedText = str;
        cell.detailLabel.text = [wjStringProcessor processAnswerDetailString:answerInfo.answerContent];
        cell.questionLabel.text = [wjStringProcessor filterHTMLWithString:tmp.questionContent];
        [cell loadAvatarImageWithApartURL:answerInfo.avatarFile];
    } else {
        NSString *actionString;
        if ([tmp.postType isEqualToString:@"question"]) {
            // 是提问的
            actionString = [NSString stringWithFormat:@"%@ 发布了问题", tmp.userInfo.nickName];
            cell.questionLabel.text = [wjStringProcessor filterHTMLWithString:tmp.questionContent];
        } else if ([tmp.postType isEqualToString:@"article"]) {
            actionString = [NSString stringWithFormat:@"%@ 发布了文章", tmp.userInfo.nickName];
            cell.questionLabel.text = tmp.title;
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:actionString];
        [str addAttribute:NSForegroundColorAttributeName value:[wjAppearanceManager userActionTextColor] range:NSMakeRange(0, [tmp.userInfo.nickName length])];
        cell.actionLabel.attributedText = str;
        cell.detailLabel.text = @"";
        [cell loadAvatarImageWithApartURL:tmp.userInfo.avatarFile];
    }
    cell.actionLabel.tag = row;
    cell.questionLabel.tag = row;
    cell.detailLabel.tag = row;
    cell.avatarView.tag = row;
    cell.delegate = self;
    return cell;
}

//- (CGFloat)heightOfLabelWithTextString:(NSString *)textString {
//    CGFloat width = self.tableView.frame.size.width - 32;
//    
//    UILabel *gettingSizeLabel = [[UILabel alloc]init];
//    gettingSizeLabel.text = textString;
//    gettingSizeLabel.font = [UIFont systemFontOfSize:17];
//    gettingSizeLabel.numberOfLines = 0;
//    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    CGSize maxSize = CGSizeMake(width, 1000.0);
//    
//    CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
//    return size.height;
//}

// Cell Delegate

- (void)pushUserControllerWithRow:(NSUInteger)row {
    NSInteger uid = 0;
    ExploreCell *tmp = dataInTable[row];
    if (tmp.answerUsers.count > 0) {
        AnswerInfo *answerInfo = tmp.answerUsers[0];
        if (answerInfo.uid != -1) {
            uid = answerInfo.uid;
            UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
            uVC.hidesBottomBarWhenPushed = YES;
            uVC.userId = [NSString stringWithFormat:@"%ld", (long)uid];
            [self.navigationController pushViewController:uVC animated:YES];
        } else {
            [MsgDisplay showErrorMsg:@"无法查看匿名用户~"];
        }
    } else {
        if (tmp.userInfo.uid != -1) {
            uid = tmp.userInfo.uid;
            UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
            uVC.hidesBottomBarWhenPushed = YES;
            uVC.userId = [NSString stringWithFormat:@"%ld", (long)uid];
            [self.navigationController pushViewController:uVC animated:YES];
        } else {
            [MsgDisplay showErrorMsg:@"无法查看匿名用户~"];
        }
    }
}

- (void)pushQuestionControllerWithRow:(NSUInteger)row {
    ExploreCell *tmp = dataInTable[row];
    if ([tmp.postType isEqualToString:@"question"]) {
        // 是提问的
        QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
        qVC.questionId = [NSString stringWithFormat:@"%ld", (long)tmp.questionId];
        qVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qVC animated:YES];
    } else if ([tmp.postType isEqualToString:@"article"]) {
        DetailViewController *aVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        aVC.answerId = [NSString stringWithFormat:@"%ld", (long)tmp.id];
        aVC.detailType = DetailTypeArticle;
        aVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aVC animated:YES];
    }
    
}

- (void)pushDetailControllerWithRow:(NSUInteger)row {
    ExploreCell *tmp = dataInTable[row];
    DetailViewController *aVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    aVC.answerId = [NSString stringWithFormat:@"%ld", (long)((AnswerInfo *)tmp.answerUsers[0]).answerId];
    aVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aVC animated:YES];
}


@end
