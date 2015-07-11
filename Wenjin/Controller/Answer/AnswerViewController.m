//
//  AnswerViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerDataManager.h"
#import "wjStringProcessor.h"
#import "MsgDisplay.h"
#import "wjAPIs.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "UserViewController.h"
#import "UIImageView+AFNetworking.h"
#import "wjOperationManager.h"
#import <KVOController/FBKVOController.h>
#import "AnswerInfo.h"
#import "AnswerCommentTableViewController.h"
#import "wjAppearanceManager.h"
#import "WeChatMomentsActivity.h"
#import "WeChatSessionActivity.h"
#import "OpenInSafariActivity.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController {
    NSInteger voteValue;
    UIColor *notVotedColor;
    UIColor *votedColor;
    
    NSString *questionId;
    NSString *answerSummary;
}

@synthesize answerId;

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
    
    [AnswerDataManager getAnswerDataWithAnswerID:answerId success:^(AnswerInfo *ansData) {
        NSString *processedHTML = [wjStringProcessor convertToBootstrapHTMLWithExtraBlankLinesWithContent:ansData.answerContent];
        [answerContentView loadHTMLString:processedHTML baseURL:[NSURL URLWithString:[wjAPIs baseURL]]];
        userNameLabel.text = ansData.nickName;
        self.title = [NSString stringWithFormat:@"%@ 的回答", ansData.nickName];
        NSString *ans = [wjStringProcessor processAnswerDetailString:ansData.answerContent];
        NSString *ansStr = (ans.length > 60) ? [NSString stringWithFormat:@"%@...", [ans substringToIndex:60]] : ans;
        answerSummary = [NSString stringWithFormat:@"%@ 的回答：%@", ansData.nickName, ansStr];
        userSigLabel.text = ansData.signature;
        [userAvatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], ansData.avatarFile]] placeholderImage:[UIImage imageNamed:@"placeholderAvatar.png"]];
        
        voteValue = ansData.voteValue;
        [self setValue:@(ansData.agreeCount) forKey:@"agreeCount"];
        if (voteValue == 0) {
            [agreeImageView setTintColor:notVotedColor];
        } else {
            [agreeImageView setTintColor:votedColor];
        }

        [agreeBtn addTarget:self action:@selector(voteOperation) forControlEvents:UIControlEventTouchUpInside];
        
        questionId = [NSString stringWithFormat:@"%ld", ansData.questionId];
        
        UITapGestureRecognizer *userTapRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(id weakSender, UIGestureRecognizerState state, CGPoint location) {
            if (ansData.uid != -1) {
                UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
                uVC.userId = [NSString stringWithFormat:@"%ld", ansData.uid];
                [self.navigationController pushViewController:uVC animated:YES];
            } else {
                [MsgDisplay showErrorMsg:@"无法查看匿名用户哦~"];
            }
        }];
        [userTapRecognizer setNumberOfTapsRequired:1];
        [userInfoView setUserInteractionEnabled:YES];
        [userInfoView addGestureRecognizer:userTapRecognizer];
        
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
    }];
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleString message:msgString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:agreeActionString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
    }];
    UIAlertAction *disagreeAction = [UIAlertAction actionWithTitle:disagreeActionString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:agreeAction];
    [alertController addAction:disagreeAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
