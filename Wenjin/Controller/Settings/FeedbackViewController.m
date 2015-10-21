//
//  FeedbackViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/20.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackForm.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "MsgDisplay.h"
#import "PostDataManager.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize formController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"反馈";
    
    formController = [[FXFormController alloc]init];
    formController.tableView = self.tableView;
    formController.delegate = self;
    formController.form = [[FeedbackForm alloc]init];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id weakSender) {
        FeedbackForm *form = (FeedbackForm *)self.formController.form;
        NSString *titleStr = form.title;
        NSString *msgStr = form.message;
        if (titleStr.length > 0 && msgStr.length > 0) {
            [PostDataManager postFeedbackWithTitle:titleStr message:msgStr success:^{
                [MsgDisplay showSuccessMsg:@"感谢您的反馈！"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *errStr) {
                [MsgDisplay showErrorMsg:errStr];
            }];
        } else {
            [MsgDisplay showErrorMsg:@"反馈尚未填写完全哦"];
        }
        
    }];
    [self.navigationItem setRightBarButtonItem:doneBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
