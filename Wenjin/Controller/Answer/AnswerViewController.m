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
#import "ALActionBlocks.h"
#import "UserViewController.h"
#import "UIImageView+AFNetworking.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

@synthesize answerId;

@synthesize userAvatarView;
@synthesize userNameLabel;
@synthesize userSigLabel;
@synthesize agreeBtn;
@synthesize answerContentView;
@synthesize userInfoView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"回答";
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [AnswerDataManager getAnswerDataWithAnswerID:answerId success:^(NSDictionary *ansData) {
        NSString *processedHTML = [wjStringProcessor convertToBootstrapHTMLWithContent:ansData[@"answer_content"]];
        [answerContentView loadHTMLString:processedHTML baseURL:[NSURL URLWithString:[wjAPIs baseURL]]];
        userNameLabel.text = ansData[@"user_name"];
        self.title = [NSString stringWithFormat:@"%@ 的回答", ansData[@"user_name"]];
        userSigLabel.text = ansData[@"signature"];
        [userAvatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], ansData[@"avatar_file"]]]];
        userAvatarView.layer.cornerRadius = userAvatarView.frame.size.width / 2;
        userAvatarView.clipsToBounds = YES;
        
        if ([ansData[@"vote_value"] isEqual:@1]) {
            // 已投票
            [agreeBtn setTitle:[NSString stringWithFormat:@"Voted %@", [ansData[@"agree_count"] stringValue]] forState:UIControlStateNormal];
            [agreeBtn handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"投票" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"取消赞同" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    //取消赞同
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [alertController addAction:agreeAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        } else {
            // 未投票
            [agreeBtn setTitle:[NSString stringWithFormat:@"Vote %@", [ansData[@"agree_count"] stringValue]] forState:UIControlStateNormal];
            [agreeBtn handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"投票" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"赞同" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    //赞同
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [alertController addAction:agreeAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        }
        
        UITapGestureRecognizer *userTapRecognizer = [[UITapGestureRecognizer alloc]initWithBlock:^(id weakSender) {
            UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
            uVC.userId = [ansData[@"uid"] stringValue];
            [self.navigationController pushViewController:uVC animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
