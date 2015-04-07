//
//  AddDetailViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "AddDetailViewController.h"
#import "data.h"
#import "wjStringProcessor.h"

@interface AddDetailViewController ()

@end

@implementation AddDetailViewController

@synthesize detailTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    detailTextView.font = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:detailTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [detailTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [detailTextView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight)];
}

- (void)dealloc {
    //使用通知中心后必须重写dealloc方法,进行释放(ARC)(非ARC还需要写上[super dealloc];)
    //removeObserver和 addObserver相对应.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done {
    [data shareInstance].postQuestionDetail = self.detailTextView.text;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
