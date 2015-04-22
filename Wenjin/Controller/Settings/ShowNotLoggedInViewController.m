//
//  ShowNotLoggedInViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/22.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "ShowNotLoggedInViewController.h"

@interface ShowNotLoggedInViewController ()

@end

@implementation ShowNotLoggedInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NotLoggedInView *notLoggedIn = [[NotLoggedInView alloc]init];
    notLoggedIn.frame = self.view.frame;
    notLoggedIn.delegate = self;
    [self.view addSubview:notLoggedIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentLoginController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
