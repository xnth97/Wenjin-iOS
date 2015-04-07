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
#import "data.h"
#import "wjCacheManager.h"
#import "wjAccountManager.h"
#import <KVOController/FBKVOController.h>

@interface MainTabBarController ()

@end

@implementation MainTabBarController

@synthesize showNotLoggedInView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[[self.tabBar.items objectAtIndex:1] setBadgeValue:@"3"];
    
    FBKVOController *kvoController = [FBKVOController controllerWithObserver:self];
    self.KVOController = kvoController;
    [self.KVOController observe:self keyPath:@"showNotLoggedInView" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if (showNotLoggedInView) {
            NotLoggedInView *notLoggedView = [[NotLoggedInView alloc]init];
            notLoggedView.frame = self.view.frame;
            notLoggedView.delegate = self;
            [self.view addSubview:notLoggedView];
        } else {
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[NotLoggedInView class]]) {
                    [view removeFromSuperview];
                }
            }
            
            [wjCookieManager loadCookieForKey:@"login"];
            [wjCacheManager loadCacheDataWithKey:@"userData" andBlock:^(id userData) {
                [data shareInstance].myUID = userData[@"uid"];
            }];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![wjAccountManager userIsLoggedIn]) {
        [self setValue:@YES forKey:@"showNotLoggedInView"];
    } else {
        [self setValue:@NO forKey:@"showNotLoggedInView"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// NotLoggedInViewDelegate

- (void)presentLoginController {
    LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:login animated:YES completion:nil];
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
