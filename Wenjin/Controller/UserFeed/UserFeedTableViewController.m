//
//  UserFeedTableViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "UserFeedTableViewController.h"
#import "SVPullToRefresh.h"
#import "MsgDisplay.h"
#import "wjStringProcessor.h"
#import "DetailViewController.h"
#import "QuestionViewController.h"
#import "wjAppearanceManager.h"
#import "AnswerInfo.h"
#import "FeedQuestion.h"
#import "JZNavigationExtension.h"

@interface UserFeedTableViewController ()

@end

@implementation UserFeedTableViewController {
    NSMutableArray *rowsData;
    NSMutableArray *dataInTable;
    NSInteger currentPage;
    NSInteger totalRows;
}

@synthesize feedType;
@synthesize userId;
@synthesize userName;
@synthesize userAvatar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // feedType = 0：提问；1：回答；2：关注
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.title = @"动态";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.allowsSelection = NO;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.jz_navigationBarBackgroundHidden = NO;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    rowsData = [[NSMutableArray alloc]init];
    dataInTable = [[NSMutableArray alloc]init];
    currentPage = 1;
    
    __weak UserFeedTableViewController *weakSelf = self;
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
    [UserDataManager getUserFeedWithType:feedType userID:userId page:currentPage success:^(NSUInteger _totalRows, NSArray *_rowsData) {
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

- (void)refreshContent {
    currentPage = 1;
    rowsData = [[NSMutableArray alloc]init];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    // feedType = 0：提问；1：回答；2：关注
    NSUInteger row = [indexPath row];
    
    NSString *title = @"";
    NSString *detail = @"";
    NSString *userAction = @"";
    
    switch (feedType) {
        case UserFeedTypeQuestion: {
            FeedQuestion *t = dataInTable[row];
            userAction = @"发布了问题";
            title = t.title;
            detail = [wjStringProcessor processAnswerDetailString:t.detail];
            break;
        }
            
        case UserFeedTypeAnswer: {
            AnswerInfo *tmp = dataInTable[row];
            userAction = @"回答了问题";
            title = tmp.questionTitle;
            detail = [wjStringProcessor processAnswerDetailString:tmp.answerContent];
            break;
        }
            
        case UserFeedTypeFollowQuestion: {
            FeedQuestion *tmp = dataInTable[row];
            userAction = @"关注了问题";
            title = tmp.title;
            break;
        }
            
        default:
            break;
    }
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@", userName, userAction]];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[wjAppearanceManager userActionTextColor] range:NSMakeRange(0, userName.length)];
    cell.actionLabel.attributedText = attriStr;
    cell.questionLabel.text = title;
    cell.detailLabel.text = [wjStringProcessor getSummaryFromString:detail lengthLimit:70];
    [cell loadAvatarImageWithApartURL:userAvatar];
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
//    gettingSizeLabel.numberOfLines = 3;
//    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    CGSize maxSize = CGSizeMake(width, 1000.0);
//    
//    CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
//    return size.height;
//}

// HomeCellDelegate

- (void)pushDetailControllerWithRow:(NSUInteger)row {
    if (feedType == UserFeedTypeAnswer) {
        AnswerInfo *tmp = dataInTable[row];
        DetailViewController *aVC = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
        aVC.answerId = [NSString stringWithFormat:@"%ld", (long)tmp.answerId];
        [self.navigationController pushViewController:aVC animated:YES];
    } else if (feedType == UserFeedTypeQuestion) {
        QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
        if ((feedType == UserFeedTypeQuestion) || (feedType == UserFeedTypeFollowQuestion)) {
            FeedQuestion *tmp = dataInTable[row];
            qVC.questionId = [NSString stringWithFormat:@"%ld", (long)tmp.feedId];
        } else if (feedType == UserFeedTypeAnswer) {
            AnswerInfo *tmp = dataInTable[row];
            qVC.questionId = [NSString stringWithFormat:@"%ld", (long)tmp.questionId];
        }
        [self.navigationController pushViewController:qVC animated:YES];
    }
}

- (void)pushQuestionControllerWithRow:(NSUInteger)row {
    QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
    if ((feedType == UserFeedTypeQuestion) || (feedType == UserFeedTypeFollowQuestion)) {
        FeedQuestion *tmp = dataInTable[row];
        qVC.questionId = [NSString stringWithFormat:@"%ld", (long)tmp.feedId];
    } else if (feedType == UserFeedTypeAnswer) {
        AnswerInfo *tmp = dataInTable[row];
        qVC.questionId = [NSString stringWithFormat:@"%ld", (long)tmp.questionId];
    }
    [self.navigationController pushViewController:qVC animated:YES];
}

- (void)pushUserControllerWithRow:(NSUInteger)row {
    
}
#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无内容";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"desperateSmile"];
}

@end
