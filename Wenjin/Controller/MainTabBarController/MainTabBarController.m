//
//  MainTabBarController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/28.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "MainTabBarController.h"
#import "wjCookieManager.h"
#import "LoginViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[[self.tabBar.items objectAtIndex:1] setBadgeValue:@"3"];
    [wjCookieManager loadCookieForKey:@"login"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
