//
//  TopicDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/10.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "TopicDataManager.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "wjAPIs.h"

@implementation TopicDataManager

+ (void)getTopicListWithType:(NSString *)topicType andPage:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id": topicType,
                                 @"page": [NSNumber numberWithInteger:page]};
    [manager GET:[wjAPIs topicList] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicData = [operation.responseString objectFromJSONString];
        if ([dicData[@"errno"] isEqual:@1]) {
            NSInteger totalRows = [(dicData[@"rsm"])[@"total_rows"] integerValue];
            if (totalRows != 0) {
                NSArray *rowsData = (dicData[@"rsm"])[@"rows"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(totalRows, rowsData);
                });
            } else {
                NSArray *rowsData = @[];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(totalRows, rowsData);
                });
            }
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
