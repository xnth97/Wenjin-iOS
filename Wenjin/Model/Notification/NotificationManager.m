//
//  NotificationManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "NotificationManager.h"
#import "JSONKit.h"
#import "AFNetworking.h"
#import "wjAPIs.h"

@implementation NotificationManager

+ (void)getUnreadNotificationNumberWithSuccess:(void (^)(NSUInteger, NSUInteger))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"platform": @"ios"};
    [manager GET:[wjAPIs notificationNumber] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicData = [operation.responseString objectFromJSONString];
        if ([dicData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success([(dicData[@"rsm"])[@"inbox_num"] integerValue], [(dicData[@"rsm"])[@"notifications_num"] integerValue]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(dicData[@"err"]);
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[wjAPIs notificationList] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [operation.responseString objectFromJSONString];
        if ([responseDic[@"errno"] isEqual:@1]) {
            NSArray *rows = (responseDic[@"rsm"])[@"rows"];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(rows);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(responseDic[@"err"]);
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
