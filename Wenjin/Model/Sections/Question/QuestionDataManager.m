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
#import <UIKit/UIKit.h>

@implementation QuestionDataManager

+ (void)getQuestionDataWithID:(NSString *)questionId success:(void (^)(QuestionInfo *, NSArray *, NSArray *, NSString *))success failure:(void (^)(NSString *))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *questionDic = @{@"id": questionId,
                                  @"platform": @"ios"};
    [manager GET:[wjAPIs viewQuestion] parameters:questionDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *quesData = (NSDictionary *)responseObject;
        if ([quesData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                QuestionInfo *info = [QuestionInfo objectWithKeyValues:(quesData[@"rsm"])[@"question_info"]];
                NSArray *answers = [AnswerInfo objectArrayWithKeyValuesArray:(quesData[@"rsm"])[@"answers"]];
                NSArray *topics = [TopicInfo objectArrayWithKeyValuesArray:(quesData[@"rsm"])[@"question_topics"]];
                success(info, answers, topics, [(quesData[@"rsm"])[@"answer_count"] stringValue]);
            });
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(quesData[@"err"]);
            });
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

@end
