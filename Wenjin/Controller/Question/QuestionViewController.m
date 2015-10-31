//
//  QuestionViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionDataManager.h"
#import "MsgDisplay.h"
#import "wjStringProcessor.h"
#import "UserViewController.h"
#import "DetailViewController.h"
#import "PostAnswerViewController.h"
#import "SVPullToRefresh.h"
#import "TopicViewController.h"
#import "BlocksKit+UIKit.h"
#import "QuestionInfo.h"
#import "TopicInfo.h"
#import "TopicViewController.h"
#import "AnswerInfo.h"
#import "MJExtension.h"
#import "OpenInSafariActivity.h"
#import "WeChatMomentsActivity.h"
#import "WeChatSessionActivity.h"
#import "WebViewJavascriptBridge.h"
#import <SafariServices/SafariServices.h>
#import "WebModalViewController.h"

@interface QuestionViewController ()

@property WebViewJavascriptBridge *bridge;

@end

@implementation QuestionViewController {
    NSMutableArray *questionAnswersData;
    QuestionInfo *questionInfo;
    NSMutableArray *questionTopics;
    NSString *questionSummary;
}

@synthesize questionTableView;
@synthesize questionId;
@synthesize shouldRefresh;
@synthesize bridge;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.questionTableView.dataSource = self;
    self.questionTableView.delegate = self;
    self.questionTableView.tableFooterView = [[UIView alloc] init];
    questionSummary = @"";
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAction handler:^(id weakSender) {
        NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://wenjin.in/?/m/question/%@", questionId]];
        NSArray *activityItems = @[shareURL, questionSummary];
        OpenInSafariActivity *openInSafari = [[OpenInSafariActivity alloc] init];
        WeChatMomentsActivity *wxMoment = [[WeChatMomentsActivity alloc] init];
        WeChatSessionActivity *wxSession = [[WeChatSessionActivity alloc] init];
        UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:@[openInSafari, wxMoment, wxSession]];
        activityController.modalPresentationStyle = UIModalPresentationPopover;
        activityController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
        [self presentViewController:activityController animated:YES completion:nil];
    }];
    [self.navigationItem setRightBarButtonItem:shareBtn];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.questionTableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.questionTableView.contentInset = insets;
        self.questionTableView.scrollIndicatorInsets = insets;
    }
    
    __weak QuestionViewController *weakSelf = self;
    [self.questionTableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [questionTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
    if (shouldRefresh) {
        [self.questionTableView triggerPullToRefresh];
    }
}

- (void)refreshData {
    [QuestionDataManager getQuestionDataWithID:questionId success:^(QuestionInfo *_questionInfo, NSArray *_questionAnswers, NSArray *_questionTopics, NSString *_answerCount) {
        questionInfo = _questionInfo;
        questionTopics = [[NSMutableArray alloc]initWithArray:_questionTopics];
        questionAnswersData = [[NSMutableArray alloc]initWithArray:_questionAnswers];
        
        self.title = [NSString stringWithFormat:@"共 %@ 回答", _answerCount];
        questionSummary = [NSString stringWithFormat:@"%@ - %@", questionInfo.questionContent, self.title];
        
        QuestionHeaderView *headerView = [[QuestionHeaderView alloc]initWithQuestionInfo:questionInfo andTopics:questionTopics];
        headerView.delegate = self;
        /*
        questionTableView.tableHeaderView = headerView;
        CGFloat headerHeight = [questionTableView.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        CGRect headerFrame = questionTableView.tableHeaderView.frame;
        headerFrame.size.height = headerHeight;
        questionTableView.tableHeaderView.frame = headerFrame;
         */
        questionTableView.tableHeaderView = headerView;
        [questionTableView reloadData];
        [questionTableView.pullToRefreshView stopAnimating];
        
        shouldRefresh = NO;
        
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
        [questionTableView.pullToRefreshView stopAnimating];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    AnswerInfo *tmpAns = (AnswerInfo *)questionAnswersData[row];
    CGFloat idealHeight = [self heightOfLabelWithTextString:[wjStringProcessor processAnswerDetailString:tmpAns.answerContent] numberOfLines:4] + 56;
    return (idealHeight < 96) ? 96 : idealHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [questionAnswersData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    QuestionAnswerTableViewCell *cell = (QuestionAnswerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QuestionAnswerTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    AnswerInfo *tmp = (AnswerInfo *)questionAnswersData[row];
    cell.userNameLabel.text = tmp.nickName;
    cell.answerContentLabel.text = [wjStringProcessor processAnswerDetailString:tmp.answerContent];
    cell.agreeCountLabel.text = (tmp.agreeCount >= 1000) ? [NSString stringWithFormat:@"%ldK", (long)tmp.agreeCount] : [NSString stringWithFormat:@"%ld", (long)tmp.agreeCount];
    [cell loadAvatarWithURL:tmp.avatarFile];
    cell.userAvatarView.tag = row;
    cell.delegate = self;
    return cell;
}

- (CGFloat)heightOfLabelWithTextString:(NSString *)textString numberOfLines:(NSUInteger)lines {
    CGFloat width = self.view.frame.size.width - 86;
    
    UILabel *gettingSizeLabel = [[UILabel alloc]init];
    gettingSizeLabel.text = textString;
    gettingSizeLabel.font = [UIFont systemFontOfSize:15];
    gettingSizeLabel.numberOfLines = lines;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maxSize = CGSizeMake(width, 1000.0);
    
    CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *aVC = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    AnswerInfo *tmpAns = (AnswerInfo *)questionAnswersData[row];
    aVC.answerId = [NSString stringWithFormat:@"%ld", (long)tmpAns.answerId];
    [self.navigationController pushViewController:aVC animated:YES];
}

// Question Push User Delegate
- (void)pushUserControllerWithRow:(NSUInteger)row {
    AnswerInfo *tmp = questionAnswersData[row];
    if (tmp.uid != -1) {
        UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        AnswerInfo *tmpAns = (AnswerInfo *)questionAnswersData[row];
        uVC.userId = [NSString stringWithFormat:@"%ld", (long)tmpAns.uid];
        [self.navigationController pushViewController:uVC animated:YES];
    } else {
        [MsgDisplay showErrorMsg:@"无法查看匿名用户~"];
    }
}

// Question Header View Delegate
- (void)presentPostAnswerController {
    PostAnswerViewController *postAnswer = [[PostAnswerViewController alloc]init];
    postAnswer.questionId = [NSString stringWithFormat:@"%ld", (long)questionInfo.questionId];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:postAnswer];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)headerDetailViewFinishLoadingWithView:(id)view {
    [questionTableView beginUpdates];
    [questionTableView setTableHeaderView:view];
    [questionTableView endUpdates];
}

- (void)tagTappedAtIndex:(NSInteger)index {
    NSString *topicId = [NSString stringWithFormat:@"%ld", (long)((TopicInfo *)questionTopics[index]).topicId];
    TopicViewController *tBA = [[TopicViewController alloc]initWithNibName:@"TopicViewController" bundle:nil];
    tBA.topicId = topicId;
    [self.navigationController pushViewController:tBA animated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // This should be fixed by Autolayout!!!!!
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    QuestionHeaderView *headerView = [[QuestionHeaderView alloc]initWithQuestionInfo:questionInfo andTopics:questionTopics];
    headerView.delegate = self;
    questionTableView.tableHeaderView = headerView;
}

- (void)URLClicked:(NSURL *)url {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:url];
        [self presentViewController:safariViewController animated:YES completion:nil];
    } else {
        WebModalViewController *webViewController = [[WebModalViewController alloc] initWithURL:url];
        [self presentViewController:webViewController animated:YES completion:nil];
    }
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
