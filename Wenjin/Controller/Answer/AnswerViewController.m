//
//  AnswerViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "AnswerViewController.h"
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
#import "AnswerCommentTableViewController.h"
#import "wjAppearanceManager.h"
#import "WeChatMomentsActivity.h"
#import "WeChatSessionActivity.h"
#import "OpenInSafariActivity.h"
#import "PopMenu.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController {
    NSInteger voteValue;
    UIColor *notVotedColor;
    UIColor *votedColor;
    
    NSString *questionId;
    NSString *answerSummary;
    NSInteger uid;
    NSString *content;
    NSString *nickName;
    NSString *signature;
    NSString *avatarFile;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"回答";
    self.automaticallyAdjustsScrollViewInsets = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    userNameLabel.text = @"";
    userSigLabel.text = @"";
    notVotedColor = [UIColor lightGrayColor];
    votedColor = [wjAppearanceManager mainTintColor];
    
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
        if (questionId != nil && answerSummary != nil) {
            NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://wenjin.twtstudio.com/?/question/%@?answer_id=%@&single=TRUE", questionId, answerId]];
            NSArray *activityItems = @[shareURL, answerSummary];
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
            [self setValue:@(ansData.agreeCount) forKey:@"agreeCount"];
            questionId = [NSString stringWithFormat:@"%ld", ansData.questionId];
            uid = ansData.uid;
            avatarFile = ansData.avatarFile;
            
            [self updateView];
            
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
    } else if (detailType == DetailTypeArticle) {
        [DetailDataManager getArticleDataWithID:answerId success:^(ArticleInfo *articleData) {
            content = articleData.message;
            nickName = articleData.nickName;
            signature = articleData.signature;
            voteValue = articleData.voteValue;
            [self setValue:@(articleData.votes) forKey:@"agreeCount"];
            uid = articleData.uid;
            avatarFile = articleData.avatarFile;
            
            [self updateView];
        } failure:^(NSString *errorStr) {
            [MsgDisplay showErrorMsg:errorStr];
        }];
    }
}

- (void)updateView {
    NSString *processedHTML = [wjStringProcessor convertToBootstrapHTMLWithExtraBlankLinesWithContent:content];
    [answerContentView loadHTMLString:processedHTML baseURL:[NSURL URLWithString:[wjAPIs baseURL]]];
    
    userNameLabel.text = nickName;
    self.title = [NSString stringWithFormat:@"%@ 的回答", nickName];
    NSString *ans = [wjStringProcessor processAnswerDetailString:content];
    NSString *ansStr = (ans.length > 60) ? [NSString stringWithFormat:@"%@...", [ans substringToIndex:60]] : ans;
    answerSummary = [NSString stringWithFormat:@"%@ 的回答：%@", nickName, ansStr];
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
            uVC.userId = [NSString stringWithFormat:@"%ld", uid];
            [self.navigationController pushViewController:uVC animated:YES];
        } else {
            [MsgDisplay showErrorMsg:@"无法查看匿名用户哦~"];
        }
    }];
    [userTapRecognizer setNumberOfTapsRequired:1];
    [userInfoView setUserInteractionEnabled:YES];
    [userInfoView addGestureRecognizer:userTapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)voteOperation {
    
    NSString *titleString;
    NSString *msgString;
    NSString *agreeActionString;
    NSString *disagreeActionString;
    NSString *agreeIcon = @"voteAgree";
    NSString *disagreeIcon = @"voteDisagree";
    
    titleString = NSLocalizedString(@"Vote", nil);
    
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
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:2];
    MenuItem *agreeItem = [[MenuItem alloc] initWithTitle:agreeActionString iconName:agreeIcon glowColor:[UIColor grayColor]];
    [items addObject:agreeItem];
    MenuItem *disagreeItem = [[MenuItem alloc] initWithTitle:disagreeActionString iconName:disagreeIcon glowColor:[UIColor grayColor]];
    [items addObject:disagreeItem];
    
    PopMenu *voteMenu = [[PopMenu alloc] initWithFrame:self.view.bounds items:items];
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
            default:
                break;
        }
    }];
    [voteMenu showMenuAtView:self.navigationController.view];
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleString message:msgString preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:agreeActionString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [wjOperationManager voteAnswerWithAnswerID:answerId operation:1 success:^{
//            switch (voteValue) {
//                case 1:
//                    voteValue = 0;
//                    [self setValue:[NSNumber numberWithInteger:agreeCount - 1] forKey:@"agreeCount"];
//                    [agreeImageView setTintColor:notVotedColor];
//                    break;
//                    
//                case 0:
//                    voteValue = 1;
//                    [self setValue:[NSNumber numberWithInteger:agreeCount + 1] forKey:@"agreeCount"];
//                    [agreeImageView setTintColor:votedColor];
//                    break;
//                    
//                case -1:
//                    voteValue = 1;
//                    [self setValue:[NSNumber numberWithInteger:agreeCount + 1] forKey:@"agreeCount"];
//                    [agreeImageView setTintColor:votedColor];
//                    break;
//                    
//                default:
//                    break;
//            }
//        } failure:^(NSString *errStr) {
//            [MsgDisplay showErrorMsg:errStr];
//        }];
//    }];
//    UIAlertAction *disagreeAction = [UIAlertAction actionWithTitle:disagreeActionString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [wjOperationManager voteAnswerWithAnswerID:answerId operation:-1 success:^{
//            switch (voteValue) {
//                case 1:
//                    voteValue = -1;
//                    [self setValue:[NSNumber numberWithInteger:agreeCount - 1] forKey:@"agreeCount"];
//                    [agreeImageView setTintColor:notVotedColor];
//                    break;
//                    
//                case 0:
//                    voteValue = -1;
//                    [agreeImageView setTintColor:notVotedColor];
//                    break;
//                    
//                case -1:
//                    voteValue = 0;
//                    [agreeImageView setTintColor:notVotedColor];
//                    break;
//                    
//                default:
//                    break;
//            }
//        } failure:^(NSString *errStr) {
//            [MsgDisplay showErrorMsg:errStr];
//        }];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
//    [alertController addAction:agreeAction];
//    [alertController addAction:disagreeAction];
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)voteAgreeAction {
    [wjOperationManager voteAnswerWithAnswerID:answerId operation:1 success:^{
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
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
    }];
}

- (void)voteDisagreeAction {
    [wjOperationManager voteAnswerWithAnswerID:answerId operation:-1 success:^{
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
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
    }];
}

- (IBAction)pushCommentViewController {
    AnswerCommentTableViewController *commentVC = [[AnswerCommentTableViewController alloc]initWithStyle:UITableViewStylePlain];
    commentVC.answerId = answerId;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
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
