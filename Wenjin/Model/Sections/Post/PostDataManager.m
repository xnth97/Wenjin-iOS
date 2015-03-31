//
//  PostDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "PostDataManager.h"
#import "JSONKit.h"
#import "AFNetworking.h"
#import "wjAPIs.h"

@implementation PostDataManager

+ (void)postQuestionWithParameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[wjAPIs postQuestion] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObj) {
        
        NSDictionary *pqDic = [operation.responseString objectFromJSONString];
        if ([pqDic[@"errno"] isEqual: @1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success((pqDic[@"rsm"])[@"question_id"]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(pqDic[@"err"]);
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

@end
