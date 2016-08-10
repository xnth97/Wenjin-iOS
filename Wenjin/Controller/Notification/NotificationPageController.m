//
//  NotificationPageController.m
//  Wenjin
//
//  Created by Qin Yubo on 15/12/13.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import "NotificationPageController.h"
#import "NotificationTableViewController.h"
#import "wjAppearanceManager.h"
#import "JZNavigationExtension.h"

@interface NotificationPageController ()

@end

@implementation NotificationPageController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self) {
        self.viewControllerClasses = @[[NotificationTableViewController class], [NotificationTableViewController class]];
        self.titles = @[@"未读", @"已读"];
        self.keys = [@[@"notificationIsReadOrNot", @"notificationIsReadOrNot"] mutableCopy];
        self.values = [@[@NO, @YES] mutableCopy];
        
        // customization
        self.pageAnimatable = YES;
        self.titleSizeSelected = 15.0;
        self.titleSizeNormal = 15.0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleColorSelected = [wjAppearanceManager mainTintColor];
        self.titleColorNormal = [UIColor darkGrayColor];
        //        self.menuItemWidth = 100;
        self.bounces = YES;
        self.menuHeight = [wjAppearanceManager pageMenuHeight];
        self.menuViewBottom = -(self.menuHeight + 64.0);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.menuView.layer.shadowColor = [wjAppearanceManager pageShadowColor].CGColor;
    self.menuView.layer.shadowOffset = [wjAppearanceManager pageShadowOffset];
    self.menuView.layer.shadowOpacity = [wjAppearanceManager pageShadowOpacity];
    self.menuView.layer.shadowRadius = [wjAppearanceManager pageShadowRadius];
    self.jz_navigationBarBackgroundHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)refresh:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH object:nil];
}

- (IBAction)clearAll:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CLEAR_ALL object:nil];
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
