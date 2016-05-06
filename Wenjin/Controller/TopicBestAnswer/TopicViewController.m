//
//  TopicBestAnswerViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/15.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "TopicViewController.h"
#import "MsgDisplay.h"
#import "TopicDataManager.h"
#import "wjStringProcessor.h"
#import "data.h"
#import "UIImageView+AFNetworking.h"
#import "wjAPIs.h"
#import <KVOController/FBKVOController.h>
#import "wjOperationManager.h"
#import "wjAppearanceManager.h"
#import "UserViewController.h"
#import "DetailViewController.h"
#import "QuestionViewController.h"
#import "TopicInfo.h"
#import "TopicBestAnswerCell.h"
#import "SVPullToRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UINavigationController+JZExtension.h"
#import <KVOController/NSObject+FBKVOController.h>

@interface TopicViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation TopicViewController {
    NSMutableArray *rowsData;
    NSInteger currentPage;
}

@synthesize topicHeaderView;
@synthesize topicDescription;
@synthesize topicImage;
@synthesize topicTitle;
@synthesize focusTopic;
@synthesize bestAnswerTableView;
@synthesize topicId;

@synthesize topicFollowed;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    currentPage = 1;
    
    bestAnswerTableView.delegate = self;
    bestAnswerTableView.dataSource = self;
    bestAnswerTableView.tableFooterView = [[UIView alloc]init];
    bestAnswerTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 130 - 64)];
    bestAnswerTableView.allowsSelection = NO;
    bestAnswerTableView.emptyDataSetSource = self;
    bestAnswerTableView.emptyDataSetDelegate = self;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = bestAnswerTableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        bestAnswerTableView.contentInset = insets;
        bestAnswerTableView.scrollIndicatorInsets = insets;
    }
    
    topicImage.layer.cornerRadius = topicImage.frame.size.width / 2;
    topicImage.clipsToBounds = YES;
    
    topicTitle.text = @"";
    topicDescription.text = @"";
    focusTopic.hidden = YES;
    [focusTopic setTitle:@"" forState:UIControlStateNormal];
    
    [topicHeaderView addSubview:({
        UIView *splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, topicHeaderView.frame.size.height - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
        [splitLine setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
        splitLine;
    })];
    
    rowsData = [[NSMutableArray alloc]init];
    
    __weak TopicViewController *weakSelf = self;
    [bestAnswerTableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshContent];
    }];
    [bestAnswerTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf nextPage];
    }];
    
    topicFollowed = NO;
    FBKVOController *kvoController = [FBKVOController controllerWithObserver:self];
    self.KVOController = kvoController;
    [self.KVOController observe:self keyPath:@"topicFollowed" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if (topicFollowed == YES) {
            [focusTopic setTitle:@"取消关注" forState:UIControlStateNormal];
        } else {
            [focusTopic setTitle:@"关注" forState:UIControlStateNormal];
        }
    }];
    
    bestAnswerTableView.estimatedRowHeight = 93;
    bestAnswerTableView.rowHeight = UITableViewAutomaticDimension;
    
    [TopicDataManager getTopicInfoWithTopicID:topicId userID:[data shareInstance].myUID success:^(TopicInfo *topicInfo) {
        self.title = topicInfo.topicTitle;
        topicTitle.text = topicInfo.topicTitle;
        topicDescription.text = topicInfo.topicDescription;
        [topicImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs topicImagePath], topicInfo.topicPic]] placeholderImage:[UIImage imageNamed:@"placeholderTopic.png"]];
        if (topicInfo.hasFocus == 0) {
            [self setValue:@NO forKey:@"topicFollowed"];
        } else if (topicInfo.hasFocus == 1) {
            [self setValue:@YES forKey:@"topicFollowed"];
        }
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
    }];
    
    [self refreshContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getList {
    [TopicDataManager getTopicBestAnswerWithTopicID:topicId page:currentPage success:^(NSUInteger _totalRows, NSArray *_rows) {
        
        focusTopic.hidden = NO;
        if (_totalRows != 0) {
            if (currentPage == 1) {
                [rowsData removeAllObjects];
                [bestAnswerTableView reloadData];
                rowsData = [[NSMutableArray alloc] initWithArray:_rows];
            } else if (currentPage > 1) {
                [rowsData addObjectsFromArray:_rows];
            }
        } else {
            if (currentPage > 1) {
                currentPage --;
                [MsgDisplay showErrorMsg:@"已到最后一页"];
            }
        }
        [bestAnswerTableView reloadData];
        [bestAnswerTableView.pullToRefreshView stopAnimating];
        [bestAnswerTableView.infiniteScrollingView stopAnimating];
        
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
        [bestAnswerTableView.pullToRefreshView stopAnimating];
        [bestAnswerTableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)refreshContent {
    currentPage = 1;
    [self getList];
}

- (void)nextPage {
    currentPage ++;
    [self getList];
}

- (IBAction)followTopic {
    [wjOperationManager followTopicWithTopicID:topicId success:^(NSString *_type) {
        
        if ([_type isEqualToString:@"add"]) {
            [self setValue:@YES forKey:@"topicFollowed"];
        } else if ([_type isEqualToString:@"remove"]) {
            [self setValue:@NO forKey:@"topicFollowed"];
        }
        
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rowsData count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSUInteger row = [indexPath row];
//    NSString *questionTitle = ((rowsData[row])[@"question_info"])[@"question_content"];
//    NSString *detailStr = [wjStringProcessor processAnswerDetailString:((rowsData[row])[@"answer_info"])[@"answer_content"]];
//    return 56 + [self heightOfLabelWithTextString:questionTitle fontSize:17.0 andNumberOfLines:0] + [self heightOfLabelWithTextString:detailStr fontSize:15.0 andNumberOfLines:3];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    TopicBestAnswerCell *tmp = rowsData[row];
    NSString *actionString;
    if ([tmp.answerInfo.answerContent isEqualToString:@""]) {
        actionString = [NSString stringWithFormat:@"%@ 发布了问题", tmp.answerInfo.nickName];
    } else {
        actionString = [NSString stringWithFormat:@"%@ 回答了问题", tmp.answerInfo.nickName];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:actionString];
    [str addAttribute:NSForegroundColorAttributeName value:[wjAppearanceManager userActionTextColor] range:NSMakeRange(0, [tmp.answerInfo.nickName length])];
    cell.actionLabel.attributedText = str;
    cell.questionLabel.text = [wjStringProcessor filterHTMLWithString:tmp.questionInfo.questionContent];
    cell.detailLabel.text = [wjStringProcessor getSummaryFromString:tmp.answerInfo.answerContent lengthLimit:70];
    cell.actionLabel.tag = row;
    cell.questionLabel.tag = row;
    cell.detailLabel.tag = row;
    cell.avatarView.tag = row;
    cell.delegate = self;
    [cell loadAvatarImageWithApartURL:tmp.answerInfo.avatarFile];
    
    return cell;

}

//- (CGFloat)heightOfLabelWithTextString:(NSString *)textString fontSize:(CGFloat)fontSize andNumberOfLines:(NSUInteger)lines {
//    CGFloat width = bestAnswerTableView.frame.size.width - 32;
//    
//    UILabel *gettingSizeLabel = [[UILabel alloc]init];
//    gettingSizeLabel.text = textString;
//    gettingSizeLabel.font = [UIFont systemFontOfSize:fontSize];
//    gettingSizeLabel.numberOfLines = lines;
//    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    CGSize maxSize = CGSizeMake(width, 1000.0);
//    
//    CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
//    return size.height;
//}

// HomeCellDelegate

- (void)pushUserControllerWithRow:(NSUInteger)row {
    TopicBestAnswerCell *tmp = rowsData[row];
    if (tmp.answerInfo.uid != -1) {
        UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        uVC.userId = [NSString stringWithFormat:@"%ld", (long)tmp.answerInfo.uid];
        [self.navigationController pushViewController:uVC animated:YES];
    } else {
        [MsgDisplay showErrorMsg:@"无法查看匿名用户~"];
    }
}

- (void)pushQuestionControllerWithRow:(NSUInteger)row {
    TopicBestAnswerCell *tmp = rowsData[row];
    QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
    qVC.questionId = [NSString stringWithFormat:@"%ld", (long)tmp.questionInfo.questionId];
    [self.navigationController pushViewController:qVC animated:YES];
}

- (void)pushDetailControllerWithRow:(NSUInteger)row {
    TopicBestAnswerCell *tmp = rowsData[row];
    if (![tmp.answerInfo.answerContent isEqualToString:@""]) {
        DetailViewController *aVC = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
        aVC.answerId = [NSString stringWithFormat:@"%ld", (long)tmp.answerInfo.answerId];
        [self.navigationController pushViewController:aVC animated:YES];
    }
}

#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"当前话题下暂无回答";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"desperateSmile"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
