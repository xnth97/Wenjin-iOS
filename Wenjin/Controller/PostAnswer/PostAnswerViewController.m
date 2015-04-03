//
//  PostAnswerViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "PostAnswerViewController.h"
#import "ALActionBlocks.h"
#import "PostDataManager.h"
#import "MsgDisplay.h"
#import "QuestionViewController.h"

@interface PostAnswerViewController ()

@end

@implementation PostAnswerViewController

@synthesize answerView;
@synthesize questionId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加回答";
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel block:^(id weakSender) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone block:^(id weakSender) {
        NSDictionary *parameters = @{@"question_id": questionId,
                                     @"answer_content": answerView.text};
        [PostDataManager postAnswerWithParameters:parameters success:^(NSString *answerId) {
            [MsgDisplay showSuccessMsg:@"答案添加成功！"];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                // 回调以后如何刷新 QuestionViewController
            
                
                
            }];
            
        } failure:^(NSString *errorStr) {
            [MsgDisplay showErrorMsg:errorStr];
        }];
        
    }];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    
    [answerView becomeFirstResponder];
    
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
