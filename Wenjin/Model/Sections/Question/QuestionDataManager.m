//
//  QuestionDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "QuestionDataManager.h"
#import "wjAPIs.h"
#import "AFNetworking.h"
#import "JSONKit.h"

@implementation QuestionDataManager

+ (void)getQuestionDataWithID:(NSString *)questionId success:(void (^)(NSDictionary *, NSArray *, NSArray *, NSString *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *questionDic = @{@"id": questionId};
    [manager GET:[wjAPIs viewQuestion] parameters:questionDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *quesData = [operation.responseString objectFromJSONString];
        if ([quesData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success((quesData[@"rsm"])[@"question_info"], (quesData[@"rsm"])[@"answers"], (quesData[@"rsm"])[@"question_topics"], [(quesData[@"rsm"])[@"answer_count"] stringValue]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(quesData[@"err"]);
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

@end