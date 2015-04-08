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
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
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
                // 回调以后刷新 QuestionViewController
                [self.navigationController.presentingViewController setValue:@YES forKey:@"shouldRefresh"];
            }];
            
        } failure:^(NSString *errorStr) {
            [MsgDisplay showErrorMsg:errorStr];
        }];
        
    }];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    
    answerView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    answerView.font = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:answerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [answerView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [answerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight)];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
