//
//  ProfileEditTableViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "ProfileEditTableViewController.h"
#import "ProfileEditForm.h"
#import "data.h"
#import "wjAccountManager.h"
#import "MsgDisplay.h"
#import "JZNavigationExtension.h"

@interface ProfileEditTableViewController ()

@end

@implementation ProfileEditTableViewController

@synthesize formController;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    formController = [[FXFormController alloc] init];
    formController.tableView = self.tableView;
    formController.delegate = self;
    formController.form = [[ProfileEditForm alloc] init];
    
    self.jz_navigationBarBackgroundHidden = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitInfo {
    [MsgDisplay showLoading];
    ProfileEditForm *form = (ProfileEditForm *)self.formController.form;
    NSString *nickname = form.nickname;
    __block UIImage *avatar = form.avatar;
    NSDate *birthday = form.birthday;
    NSString *signature = form.signature;
    [wjAccountManager profileSettingWithUID:[data shareInstance].myUID nickName:nickname signature:signature birthday:birthday success:^{
        if (![avatar isEqual:([data shareInstance].myInfo)[@"avatar"]]) {
            if (avatar.size.width > 600) {
                CGSize newSize = CGSizeMake(600, 600 * avatar.size.height / avatar.size.width);
                UIGraphicsBeginImageContext(newSize);
                [avatar drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                avatar = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            NSData *avatarData = UIImageJPEGRepresentation(avatar, 0.5);
            [wjAccountManager uploadAvatar:avatarData success:^{
                [self.navigationController popViewControllerAnimated:YES];
                [MsgDisplay dismiss];
                [MsgDisplay showSuccessMsg:@"个人资料修改成功！"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAvatar" object:nil];
            } failure:^(NSString *errorStr) {
                [MsgDisplay dismiss];
                [MsgDisplay showErrorMsg:errorStr];
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [MsgDisplay dismiss];
            [MsgDisplay showSuccessMsg:@"个人资料修改成功！"];
        }
    } failure:^(NSString *errorStr) {
        [MsgDisplay showErrorMsg:errorStr];
    }];
}

@end
