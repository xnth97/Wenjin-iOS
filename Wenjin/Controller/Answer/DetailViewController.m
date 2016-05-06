//
//  AnswerViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailDataManager.h"
#import "wjStringProcessor.h"
#import "MsgDisplay.h"
#import "wjAPIs.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "UserViewController.h"
#import "UIImageView+AFNetworking.h"
#import "wjOperationManager.h"
#import <KVOController/FBKVOController.h>
#import "AnswerInfo.h"
#import "ArticleInfo.h"
#import "CommentViewController.h"
#import "wjAppearanceManager.h"
#import "WeChatMomentsActivity.h"
#import "WeChatSessionActivity.h"
#import "OpenInSafariActivity.h"
#import "PopMenu.h"
#import "QuestionViewController.h"
#import "WebViewJavascriptBridge.h"
#import "IDMPhotoBrowser.h"
#import <SafariServices/SafariServices.h>
#import "WebModalViewController.h"
#import <KVOController/NSObject+FBKVOController.h>

@interface DetailViewController ()<IDMPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSigLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIWebView *answerContentView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *agreeImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *questionItem;
@property WebViewJavascriptBridge *bridge;

@property (nonatomic) NSInteger agreeCount;

@end

@implementation DetailViewController {
    NSInteger voteValue;
    UIColor *notVotedColor;
    UIColor *votedColor;
    
    NSString *titleString;
    NSString *summaryString;
    
    NSInteger thankValue;
    NSInteger uninterestedValue;
    
    NSString *questionId;
    NSInteger uid;
    NSString *content;
    NSString *nickName;
    NSString *signature;
    NSString *avatarFile;
    NSInteger timeStamp;
    
    NSMutableArray *photos;
}

@synthesize answerId;
@synthesize detailType;

@synthesize userAvatarView;
@synthesize userNameLabel;
@synthesize userSigLabel;
@synthesize agreeBtn;
@synthesize answerContentView;
@synthesize userInfoView;
@synthesize agreeCount;
@synthesize agreeImageView;
@synthesize commentItem;
@synthesize questionItem;

@synthesize bridge;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"回答";
    self.automaticallyAdjustsScrollViewInsets = YES;
    
//    [WebViewJavascriptBridge enableLogging];
    bridge = [WebViewJavascriptBridge bridgeForWebView:answerContentView];
    [bridge registerHandler:@"imgCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"Callback: %@", data);
        [self presentHDImageWithURL:data];
        responseCallback(@"jsbridge load successfully");
    }];
    
    userNameLabel.text = @"";
    userSigLabel.text = @"";
    notVotedColor = [UIColor lightGrayColor];
    votedColor = [wjAppearanceManager mainTintColor];
    photos = [[NSMutableArray alloc] init];
    
    agreeImageView.image = [agreeImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [agreeImageView setTintColor:notVotedColor];
    
    userAvatarView.layer.cornerRadius = userAvatarView.frame.size.width / 2;
    userAvatarView.clipsToBounds = YES;
    
    [userInfoView addSubview:({
        UIView *splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, userInfoView.frame.size.height - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
        [splitLine setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
        splitLine;
    })];
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAction handler:^(id weakSender) {
        if ((detailType == DetailTypeAnswer && questionId != nil && summaryString != nil) || (detailType == DetailTypeArticle && answerId != nil && summaryString != nil)) {
            NSURL *shareURL;
            if (detailType == DetailTypeAnswer) {
                shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://wenjin.in/m/question/id-%@__answer_id-%@__single-TRUE", questionId, answerId]];
            } else {
                shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://wenjin.in/article/%@", answerId]];
            }
            NSArray *activityItems = @[shareURL, summaryString];
            OpenInSafariActivity *openInSafari = [[OpenInSafariActivity alloc] init];
            WeChatMomentsActivity *wxMoment = [[WeChatMomentsActivity alloc] init];
            WeChatSessionActivity *wxSession = [[WeChatSessionActivity alloc] init];
            UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:@[openInSafari, wxMoment, wxSession]];
            activityController.modalPresentationStyle = UIModalPresentationPopover;
            activityController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
            [self presentViewController:activityController animated:YES completion:nil];
        }
    }];
    [self.navigationItem setRightBarButtonItem:shareBtn];
    
    FBKVOController *kvoController = [FBKVOController controllerWithObserver:self];
    self.KVOController = kvoController;
    [self.KVOController observe:self keyPath:@"agreeCount" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if (agreeCount < 1000) {
            [agreeBtn setTitle:[NSString stringWithFormat:@"%ld", (long)agreeCount] forState:UIControlStateNormal];
        } else {
            [agreeBtn setTitle:[NSString stringWithFormat:@"%ldK", (long)agreeCount/1000] forState:UIControlStateNormal];
        }
    }];
    
    if (detailType == DetailTypeAnswer) {
        [DetailDataManager getAnswerDataWithAnswerID:answerId success:^(AnswerInfo *ansData) {
            content = ansData.answerContent;
            nickName = ansData.nickName;
            signature = ansData.signature;
            voteValue = ansData.voteValue;
            thankValue = ansData.thankValue;
            uninterestedValue = ansData.uninterested;
            [self setValue:@(ansData.agreeCount) forKey:@"agreeCount"];
            questionId = [NSString stringWithFormat:@"%ld", (long)ansData.questionId];
            uid = ansData.uid;
            avatarFile = ansData.avatarFile;
            timeStamp = ansData.addTime;
            
            if (ansData.commentCount > 0) {
                [commentItem setTitle:[NSString stringWithFormat:@"评论 (%ld)", (long)ansData.commentCount]];
            }
            
            titleString = [NSString stringWithFormat:@"%@ 的回答", nickName];
            NSString *ans = [wjStringProcessor processAnswerDetailString:content];
            NSString *ansStr = (ans.length > 60) ? [NSString stringWithFormat:@"%@...", [ans substringToIndex:60]] : ans;
            summaryString = [NSString stringWithFormat:@"%@ 的回答：%@", nickName, ansStr];
            
            [self updateView];
            
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
    } else if (detailType == DetailTypeArticle) {
        [questionItem setTitle:@""];
        self.title = @"文章";
        [DetailDataManager getArticleDataWithID:answerId success:^(ArticleInfo *articleData) {
            content = articleData.message;
            nickName = articleData.nickName;
            signature = articleData.signature;
            voteValue = articleData.voteValue;
            [self setValue:@(articleData.votes) forKey:@"agreeCount"];
            uid = articleData.uid;
            avatarFile = articleData.avatarFile;
            
            titleString = articleData.title;
            NSString *ans = [wjStringProcessor processAnswerDetailString:articleData.message];
            NSString *ansStr = (ans.length > 80) ? [NSString stringWithFormat:@"%@...", [ans substringToIndex:80]] : ans;
            summaryString = [NSString stringWithFormat:@"%@：%@", titleString, ansStr];
            
            [self updateView];
        } failure:^(NSString *errorStr) {
            [MsgDisplay showErrorMsg:errorStr];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)pushCommentViewController {
    if (answerId != nil) {
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.answerId = answerId;
        commentVC.detailType = detailType;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

- (IBAction)pushQuestionViewController {
    if (detailType == DetailTypeAnswer && questionId != nil) {
        QuestionViewController *questionVC = [[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:nil];
        questionVC.questionId = questionId;
        [self.navigationController pushViewController:questionVC animated:YES];
    }
}

#pragma mark - Private Methods

- (void)updateView {
    NSString *processedHTML;
    if (detailType == DetailTypeAnswer) {
        processedHTML = [wjStringProcessor convertToBootstrapHTMLWithTimeWithContent:content andTimeStamp:timeStamp];
    } else {
        processedHTML = [wjStringProcessor convertToBootstrapHTMLWithExtraBlankLinesWithContent:content];
    }
    [answerContentView loadHTMLString:processedHTML baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory:YES]];
    
    userNameLabel.text = nickName;
    self.title = titleString;
    userSigLabel.text = signature;
    [userAvatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], avatarFile]] placeholderImage:[UIImage imageNamed:@"placeholderAvatar.png"]];
    
    if (voteValue == 0) {
        [agreeImageView setTintColor:notVotedColor];
    } else {
        [agreeImageView setTintColor:votedColor];
    }
    
    [agreeBtn addTarget:self action:@selector(voteOperation) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *userTapRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(id weakSender, UIGestureRecognizerState state, CGPoint location) {
        if (uid != -1) {
            UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
            uVC.userId = [NSString stringWithFormat:@"%ld", (long)uid];
            [self.navigationController pushViewController:uVC animated:YES];
        } else {
            [MsgDisplay showErrorMsg:@"无法查看匿名用户哦~"];
        }
    }];
    [userTapRecognizer setNumberOfTapsRequired:1];
    [userInfoView setUserInteractionEnabled:YES];
    [userInfoView addGestureRecognizer:userTapRecognizer];
}

- (void)voteOperation {
    
    NSString *msgString;
    NSString *agreeActionString;
    NSString *disagreeActionString;
    NSString *agreeIcon = @"voteAgree";
    NSString *disagreeIcon = @"voteDisagree";
    NSString *thankIcon = @"voteThank";
    NSString *uninterestedIcon = @"voteUninterested";
    
    if (voteValue == 1) {
        // 已赞同
        msgString = @"已赞同";
        agreeActionString = @"取消赞同";
        disagreeActionString = @"反对";
    } else if (voteValue == -1) {
        // 已反对
        msgString = @"已反对";
        agreeActionString = @"赞同";
        disagreeActionString = @"取消反对";
    } else if (voteValue == 0) {
        // 无操作
        msgString = @"";
        agreeActionString = @"赞同";
        disagreeActionString = @"反对";
    }
    
    NSString *thankActionString = (thankValue == 0) ? @"感谢" : @"已感谢";
    NSString *uninterestedActionString = (uninterestedValue == 0) ? @"没有帮助" : @"已选没有帮助";
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:2];
    MenuItem *agreeItem = [[MenuItem alloc] initWithTitle:agreeActionString iconName:agreeIcon glowColor:[UIColor grayColor]];
    [items addObject:agreeItem];
    MenuItem *disagreeItem = [[MenuItem alloc] initWithTitle:disagreeActionString iconName:disagreeIcon glowColor:[UIColor grayColor]];
    [items addObject:disagreeItem];
    if (detailType == DetailTypeAnswer) {
        MenuItem *thankItem = [[MenuItem alloc] initWithTitle:thankActionString iconName:thankIcon glowColor:[UIColor grayColor]];
        [items addObject:thankItem];
        MenuItem *uninterestedItem = [[MenuItem alloc] initWithTitle:uninterestedActionString iconName:uninterestedIcon glowColor:[UIColor grayColor]];
        [items addObject:uninterestedItem];
    }
    
    PopMenu *voteMenu = [[PopMenu alloc] initWithFrame:self.navigationController.view.frame items:items];
    voteMenu.menuAnimationType = kPopMenuAnimationTypeSina;
    voteMenu.perRowItemCount = 2;
    [voteMenu setDidSelectedItemCompletion:^(MenuItem *selectedItem) {
        switch (selectedItem.index) {
            case 0:
                [self voteAgreeAction];
                break;
            case 1:
                [self voteDisagreeAction];
                break;
            case 2:
                [self voteThankAction];
                break;
            case 3:
                [self voteUninterestedAction];
                break;
            default:
                break;
        }
    }];
    [voteMenu showMenuAtView:self.navigationController.view];
}

- (void)voteAgreeAction {
    if (detailType == DetailTypeAnswer) {
        [wjOperationManager voteAnswerWithAnswerID:answerId operation:1 success:^{
            [self handleVoteValueWithAgreeOrNot:YES];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
    } else {
        [wjOperationManager voteArticleWithArticleID:answerId rating:VoteArticleRatingAgree success:^{
            [self handleVoteValueWithAgreeOrNot:YES];
        } failure:^(NSString *errorStr) {
            [MsgDisplay showErrorMsg:errorStr];
        }];
    }
}

- (void)voteDisagreeAction {
    if (detailType == DetailTypeAnswer) {
        [wjOperationManager voteAnswerWithAnswerID:answerId operation:-1 success:^{
            [self handleVoteValueWithAgreeOrNot:NO];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
    } else {
        [wjOperationManager voteArticleWithArticleID:answerId rating:VoteArticleRatingDisagree success:^{
            [self handleVoteValueWithAgreeOrNot:NO];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
    }
}

- (void)voteThankAction {
    [wjOperationManager thankAnswerOrUninterestedWithAnswerID:answerId voteAnswerType:VoteAnswerTypeThank success:^{
        if (thankValue == 0) {
            thankValue = 1;
        }
    } failure:^(NSString *errorStr) {
        [MsgDisplay showErrorMsg:errorStr];
    }];
}

- (void)voteUninterestedAction {
    [wjOperationManager thankAnswerOrUninterestedWithAnswerID:answerId voteAnswerType:VoteAnswerTypeUninterested success:^{
        if (uninterestedValue == 0) {
            uninterestedValue = 1;
        }
    } failure:^(NSString *errorStr) {
        [MsgDisplay showErrorMsg:errorStr];
    }];
}

- (void)handleVoteValueWithAgreeOrNot:(BOOL)agreed {
    if (agreed) {
        switch (voteValue) {
            case 1:
                voteValue = 0;
                [self setValue:[NSNumber numberWithInteger:agreeCount - 1] forKey:@"agreeCount"];
                [agreeImageView setTintColor:notVotedColor];
                break;
                
            case 0:
                voteValue = 1;
                [self setValue:[NSNumber numberWithInteger:agreeCount + 1] forKey:@"agreeCount"];
                [agreeImageView setTintColor:votedColor];
                break;
                
            case -1:
                voteValue = 1;
                [self setValue:[NSNumber numberWithInteger:agreeCount + 1] forKey:@"agreeCount"];
                [agreeImageView setTintColor:votedColor];
                break;
                
            default:
                break;
        }
    } else {
        switch (voteValue) {
            case 1:
                voteValue = -1;
                [self setValue:[NSNumber numberWithInteger:agreeCount - 1] forKey:@"agreeCount"];
                [agreeImageView setTintColor:notVotedColor];
                break;
                
            case 0:
                voteValue = -1;
                [agreeImageView setTintColor:notVotedColor];
                break;
                
            case -1:
                voteValue = 0;
                [agreeImageView setTintColor:notVotedColor];
                break;
                
            default:
                break;
        }
    }
}

- (void)presentHDImageWithURL:(NSString *)url {
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:@[[NSURL URLWithString:url]]];
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = NO;
    browser.delegate = self;
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0) {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[request URL]];
            [self presentViewController:safariVC animated:YES completion:nil];
        } else {
            WebModalViewController *webViewController = [[WebModalViewController alloc] initWithURL:[request URL]];
            [self presentViewController:webViewController animated:YES completion:nil];
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
