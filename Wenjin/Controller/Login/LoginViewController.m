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
#import "wjAppearanceManager.h"
#import "data.h"
#import <POP/POP.h>
#import "WebModalViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    NSString *usernameStr;
    NSString *passwordStr;
}

@synthesize usernameField;
@synthesize passwordField;
@synthesize loginBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loginBtn.tintColor = [UIColor whiteColor];
    loginBtn.backgroundColor = [wjAppearanceManager mainTintColor];
    loginBtn.layer.cornerRadius = 7.0;
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.shadowOffset = CGSizeMake(0, 20.0);
    loginBtn.layer.shadowOpacity = 0.5;
    loginBtn.layer.shadowRadius = 5.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)login {
    usernameStr = usernameField.text;
    passwordStr = passwordField.text;
    [wjCookieManager removeCookieForKey:@"login"];
    if ([usernameStr isEqualToString:@""] || [passwordStr isEqualToString:@""]) {
        [MsgDisplay showErrorMsg:@"用户名或密码不能为空哦"];
        return;
    } else {
        [MsgDisplay showLoading];
        NSDictionary *parameters = @{@"user_name": usernameStr,
                                     @"password": passwordStr};
        [wjAccountManager loginWithParameters:parameters success:^(NSString *uid, NSString *user_name, NSString *avatar_file) {
            [wjCookieManager loadCookieForKey:@"login"];
            
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
            [MsgDisplay dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSString *errStr) {
            [MsgDisplay dismiss];
            [MsgDisplay showErrorMsg:errStr];
        }];
    }
}

- (IBAction)signIn {
    WebModalViewController *webController = [[WebModalViewController alloc] initWithAddress:@"http://wenjin.in/account/green/"];
    [self presentViewController:webController animated:YES completion:nil];
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

- (IBAction)backgroundTapped {
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void)keyboardWillShow {
    if (self.view.frame.size.height <= 568) {
        POPBasicAnimation *viewAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
        CGPoint point = self.view.center;
        CGFloat halfHeight = 0.5*[[UIScreen mainScreen] bounds].size.height;
        CGFloat upHeight = (self.view.frame.size.height > 480) ? 50 : 140;
        viewAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, halfHeight - upHeight)];
        [self.view.layer pop_addAnimation:viewAnim forKey:@"viewAnimation"];
    }
}

- (void)keyboardWillHide {
    if (self.view.frame.size.height <= 568) {
        POPBasicAnimation *viewAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
        CGPoint point = self.view.center;
        CGFloat halfHeight = 0.5*[[UIScreen mainScreen] bounds].size.height;
        viewAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, halfHeight)];
        [self.view.layer pop_addAnimation:viewAnim forKey:@"viewAnimation"];
    }
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
