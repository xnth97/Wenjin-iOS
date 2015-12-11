//
//  wjOperationManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/7.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "wjOperationManager.h"
#import "AFNetworking.h"
#import "wjAPIs.h"

@implementation wjOperationManager

+ (void)followQuestionWithQuestionID:(NSString *)questionId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"question_id": questionId,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs followQuestion] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *respObj = (NSDictionary *)responseObject;
        if ([respObj[@"errno"] isEqual: @1]) {
            success((respObj[@"rsm"])[@"type"]);
        } else {
            failure(respObj[@"err"]);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error.localizedDescription);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)followPeopleWithUserID:(NSString *)uid success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs followUser] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *respObj = (NSDictionary *)responseObject;
        if ([respObj[@"errno"] isEqual: @1]) {
            success((respObj[@"rsm"])[@"type"]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else {
            failure(respObj[@"err"]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error.localizedDescription);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)voteAnswerWithAnswerID:(NSString *)answerId operation:(NSInteger)operation success:(void (^)())success failure:(void (^)(NSString *))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"answer_id": answerId,
                                 @"value": [NSNumber numberWithInteger:operation]};
    [manager POST:[NSString stringWithFormat:@"%@?platform=ios", [wjAPIs voteAnswer]] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *respObj = (NSDictionary *)responseObject;
        if ([respObj[@"errno"] isEqual: @1]) {
            success();
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else {
            failure(respObj[@"err"]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error.localizedDescription);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)followTopicWithTopicID:(NSString *)topicId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"topic_id": topicId,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs followTopic] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *respObj = (NSDictionary *)responseObject;
        if ([respObj[@"errno"] isEqual: @1]) {
            success((respObj[@"rsm"])[@"type"]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else {
            failure(respObj[@"err"]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error.localizedDescription);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)thankAnswerOrUninterestedWithAnswerID:(NSString *)answerId voteAnswerType:(NSString *)thankOrUninterested success:(void (^)())success failure:(void (^)(NSString *))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"answer_id": answerId,
                                 @"type": thankOrUninterested};
    [manager POST:[NSString stringWithFormat:@"%@?platform=ios", [wjAPIs thankAnswerAndUninterested]] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *respObj = (NSDictionary *)responseObject;
        if ([respObj[@"errno"] isEqual: @1]) {
            success();
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else {
            failure(respObj[@"err"]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error.localizedDescription);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

+ (void)voteArticleWithArticleID:(NSString *)articleId rating:(VoteArticleRating)rating success:(void (^)())success failure:(void (^)(NSString *))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"type": @"article",
                                 @"item_id": articleId,
                                 @"rating": [NSString stringWithFormat:@"%ld", (long)rating]};
    [manager POST:[NSString stringWithFormat:@"%@?platform=ios", [wjAPIs voteArticle]] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *respObj = (NSDictionary *)responseObject;
        if ([respObj[@"errno"] isEqual: @1]) {
            success();
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else {
            failure(respObj[@"err"]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error.localizedDescription);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

@end
