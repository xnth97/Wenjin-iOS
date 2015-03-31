//
//  PostViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "PostViewController.h"
#import "wjStringProcessor.h"
#import "PostDataManager.h"
#import "data.h"
#import "MsgDisplay.h"

@interface PostViewController ()

@end

@implementation PostViewController

@synthesize questionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Instaces init.
    [data shareInstance].postQuestionDetail = @"";
    [data shareInstance].postQuestionTopics = @[];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [questionView becomeFirstResponder];
}

- (IBAction)postQuestion {
    // 成功提交后需清除单例模式里的数据
    
    if ([self.questionView.text isEqualToString:@""]) {
        [MsgDisplay showErrorMsg:@"NULL"];
    } else {
        NSDictionary *parameters = @{@"question_content": self.questionView.text,
                                     @"question_detail": [data shareInstance].postQuestionDetail,
                                     @"topics": @"问津"};
        [PostDataManager postQuestionWithParameters:parameters success:^(NSString *questionId) {
            [MsgDisplay showSuccessMsg:[NSString stringWithFormat:@"Question ID: %@", questionId]];
            [data shareInstance].postQuestionDetail = @"";
            [data shareInstance].postQuestionTopics = @[];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
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
