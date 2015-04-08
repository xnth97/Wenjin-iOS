//
//  wjOperationManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/7.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "wjOperationManager.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "wjAPIs.h"

@implementation wjOperationManager

+ (void)followQuestionWithQuestionID:(NSString *)questionId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"question_id": questionId};
    [manager GET:[wjAPIs followQuestion] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *respObj = [operation.responseString objectFromJSONString];
        if ([respObj[@"errno"] isEqual: @1]) {
            success((respObj[@"rsm"])[@"type"]);
        } else {
            failure(respObj[@"err"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (void)followPeopleWithUserID:(NSString *)uid success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid};
    [manager GET:[wjAPIs followUser] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *respObj = [operation.responseString objectFromJSONString];
        if ([respObj[@"errno"] isEqual: @1]) {
            success((respObj[@"rsm"])[@"type"]);
        } else {
            failure(respObj[@"err"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (void)voteAnswerWithAnswerID:(NSString *)answerId operation:(NSInteger)operation success:(void (^)())success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"answer_id": answerId,
                                 @"value": [NSNumber numberWithInteger:operation]};
    [manager POST:[wjAPIs voteAnswer] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *respObj = [operation.responseString objectFromJSONString];
        if ([respObj[@"errno"] isEqual: @1]) {
            success();
        } else {
            failure(respObj[@"err"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

@end
