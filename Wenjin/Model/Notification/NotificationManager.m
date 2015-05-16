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

@end
