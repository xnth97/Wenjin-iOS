//
//  LoginViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "LoginViewController.h"
#import "wjAccountManager.h"
#import "MsgDisplay.h"
#import "wjCookieManager.h"
#import "HomeViewController.h"
#import "data.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    NSString *usernameStr;
    NSString *passwordStr;
}

@synthesize usernameField;
@synthesize passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login {
    usernameStr = usernameField.text;
    passwordStr = passwordField.text;
    if ([usernameStr isEqualToString:@""] || [passwordStr isEqualToString:@""]) {
        NSLog(@"username or password can't be empty.");
        return;
    } else {
        NSDictionary *parameters = @{@"user_name": usernameStr,
                                     @"password": passwordStr};
        [wjAccountManager loginWithParameters:parameters success:^(NSString *uid, NSString *user_name, NSString *avatar_file) {
            [wjCookieManager loadCookieForKey:@"login"];
            [MsgDisplay showSuccessMsg:@"Success"];
            
            if ([self.presentingViewController isKindOfClass:[UITabBarController class]]) {
                [self.presentingViewController setValue:@NO forKey:@"showNotLoggedInView"];
                
                UITabBarController *presentingTabBarController = (UITabBarController *)self.presentingViewController;
                for (UIViewController *navViewController in presentingTabBarController.viewControllers) {
                    if ([navViewController isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *navController = (UINavigationController *)navViewController;
                        UIViewController *rVC = navController.viewControllers[0];
                        if ([rVC isKindOfClass:[HomeViewController class]]) {
                            HomeViewController *hVC = (HomeViewController *)rVC;
                            hVC.shouldRefresh = YES;
                        }
                    }
                }
                
            } else {
                [self.presentingViewController.navigationController.tabBarController setValue:@NO forKey:@"showNotLoggedInView"];
            }
            
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
    }
}

- (IBAction)cancel {
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextTextField {
    [usernameField resignFirstResponder];
    [passwordField becomeFirstResponder];
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
