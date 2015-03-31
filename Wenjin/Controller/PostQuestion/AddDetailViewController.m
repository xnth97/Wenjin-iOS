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
    [self.detailTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
