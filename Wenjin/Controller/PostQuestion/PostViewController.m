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
#import "ALActionBlocks.h"

@interface PostViewController ()

@end

@implementation PostViewController {
    
}

@synthesize questionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Instaces init.
    [data shareInstance].postQuestionDetail = @"";
    [data shareInstance].postQuestionTopics = @[];
    
    questionView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    questionView.font = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:questionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    UIToolbar *accessoryToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    accessoryToolbar.barStyle = UIBarStyleDefault;
    accessoryToolbar.translucent = YES;
    
    UIBarButtonItem *addDetailBtn = [[UIBarButtonItem alloc]initWithTitle:@"添加描述" style:UIBarButtonItemStylePlain block:^(id weakSender) {
        UIStoryboard *storyboard = self.storyboard;
        UINavigationController *addDetailNav = [storyboard instantiateViewControllerWithIdentifier:@"detailNav"];
        [self presentViewController:addDetailNav animated:YES completion:nil];
    }];
    UIBarButtonItem *addTopicBtn = [[UIBarButtonItem alloc]initWithTitle:@"添加话题" style:UIBarButtonItemStylePlain block:^(id weakSender) {
        UIStoryboard *storyboard = self.storyboard;
        UINavigationController *addTopicNav = [storyboard instantiateViewControllerWithIdentifier:@"topicNav"];
        [self presentViewController:addTopicNav animated:YES completion:nil];
    }];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [accessoryToolbar setItems:@[flexibleSpace, flexibleSpace, addDetailBtn, addTopicBtn]];
    
    questionView.inputAccessoryView = accessoryToolbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [questionView becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [questionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight)];
}

- (void)dealloc {
    //使用通知中心后必须重写dealloc方法,进行释放(ARC)(非ARC还需要写上[super dealloc];)
    //removeObserver和 addObserver相对应.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)postQuestion {
    
    NSString *topicsStr = @"";
    if ([[data shareInstance].postQuestionTopics count] > 0) {
        for (int i = 0; i < [[data shareInstance].postQuestionTopics count]; i ++) {
            if (i == 0) {
                topicsStr = ([data shareInstance].postQuestionTopics)[0];
            } else {
                NSString *topic = ([data shareInstance].postQuestionTopics)[i];
                topicsStr = [NSString stringWithFormat:@"%@,%@", topicsStr, topic];
            }
        }
    }
    
    // 成功提交后需清除单例模式里的数据
    
    if ([self.questionView.text isEqualToString:@""]) {
        [MsgDisplay showErrorMsg:@"NULL"];
    } else {
        NSDictionary *parameters = @{@"question_content": self.questionView.text,
                                     @"question_detail": [data shareInstance].postQuestionDetail,
                                     @"topics": topicsStr};
        [PostDataManager postQuestionWithParameters:parameters success:^(NSString *questionId) {
            [MsgDisplay showSuccessMsg:[NSString stringWithFormat:@"Question ID: %@", questionId]];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [data shareInstance].postQuestionDetail = @"";
            [data shareInstance].postQuestionTopics = @[];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
    }
}

- (void)addTopic {
    
}

- (void)addDetail {
    
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
