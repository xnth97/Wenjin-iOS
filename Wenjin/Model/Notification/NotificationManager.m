//
//  NotificationManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "NotificationManager.h"
#import "AFNetworking.h"
#import "wjAPIs.h"
#import "NotificationCell.h"
#import "MJExtension.h"
#import "Notification.h"
#import "QuestionViewController.h"
#import "DetailViewController.h"
#import "UserViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "UINavigationController+JZExtension.h"
#import "WebModalViewController.h"
#import <SafariServices/SafariServices.h>

@implementation NotificationManager

+ (void)getUnreadNotificationNumberWithSuccess:(void (^)(NSUInteger, NSUInteger))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"platform": @"ios"};
    [manager GET:[wjAPIs notificationNumber] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success([(dicData[@"rsm"])[@"inbox_num"] integerValue], [(dicData[@"rsm"])[@"notifications_num"] integerValue]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(dicData[@"err"]);
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getNotificationDataReadOrNot:(BOOL)isRead page:(NSInteger)page success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *parameters = @{@"flag": @(isRead ? 1 : 0),
                                 @"limit": @10,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[wjAPIs notificationList] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"errno"] isEqual:@1]) {
            NSArray *rows = [NotificationCell mj_objectArrayWithKeyValuesArray:(responseDic[@"rsm"])[@"rows"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(rows);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(responseDic[@"err"]);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

+ (void)readNotificationWithNotificationID:(NSInteger)notificationId {
    NSDictionary *parameters = @{@"notification_id": [NSString stringWithFormat:@"%ld", (long)notificationId],
                                 @"platform": @"ios"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[wjAPIs readNotification] parameters:parameters progress:nil success:nil failure:nil];
}

+ (void)readAllNotificationsWithCompletionBlock:(void (^)())block {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[wjAPIs readNotification] parameters:@{@"platform": @"ios"} progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        block();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

+ (void)handleNotification:(NSDictionary *)dic {
    Notification *notification = [Notification mj_objectWithKeyValues:dic];
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    if (notification.type == 999) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0) {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:notification.url]];
            [topVC presentViewController:safariVC animated:YES completion:nil];
        } else {
            WebModalViewController *webViewController = [[WebModalViewController alloc] initWithURL:[NSURL URLWithString:notification.url]];
            [topVC presentViewController:webViewController animated:YES completion:nil];
        }
    } else {
        UIViewController *vc = [self properViewControllerWithNotification:notification];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.view.backgroundColor = [UIColor whiteColor];
        vc.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *cancel = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(id sender) {
                [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            cancel;
        });
        [topVC presentViewController:nav animated:YES completion:nil];
        [self readNotificationWithNotificationID:notification.nid];
    }
}

+ (UIViewController *)properViewControllerWithNotification:(Notification *)notification {
    if (notification.type == 102 || notification.type == 103 || notification.type == 105 || notification.type == 107 || notification.type == 108 || notification.type == 115 || notification.type == 116) {
        DetailViewController *dVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        dVC.detailType = DetailTypeAnswer;
        dVC.answerId = [NSString stringWithFormat:@"%ld", notification.relatedId];
        return dVC;
    } else if (notification.type == 101) {
        UserViewController *uVC = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
        uVC.userId = [NSString stringWithFormat:@"%ld", notification.relatedId];
        return uVC;
    } else if (notification.type == 104 || notification.type == 106 || notification.type == 110 || notification.type == 113 || notification.type == 114) {
        QuestionViewController *qVC = [[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:nil];
        qVC.questionId = [NSString stringWithFormat:@"%ld", notification.relatedId];
        return qVC;
    } else if (notification.type == 117 || notification.type == 118) {
        DetailViewController *dVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        dVC.detailType = DetailTypeArticle;
        dVC.answerId = [NSString stringWithFormat:@"%ld", notification.relatedId];
        return dVC;
    } else {
        return nil;
    }
}

@end
