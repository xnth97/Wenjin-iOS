//
//  AnswerDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "DetailDataManager.h"
#import "AFNetworking.h"
#import "wjAPIs.h"
#import "CommentInfo.h"

@implementation DetailDataManager

+ (void)getAnswerDataWithAnswerID:(NSString *)answerId success:(void (^)(AnswerInfo *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id": answerId,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs viewAnswer] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *ansData = (NSDictionary *)responseObject;
        if ([ansData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AnswerInfo *answerData = [AnswerInfo mj_objectWithKeyValues:ansData[@"rsm"]];
                success(answerData);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(ansData[@"err"]);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getAnswerCommentWithAnswerID:(NSString *)answerId success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id": answerId,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs answerComment] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *commentData = (NSDictionary *)responseObject;
        if ([commentData[@"errno"] isEqual:@1]) {
            id dataObj = commentData[@"rsm"];
            if ([dataObj isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success([CommentInfo mj_objectArrayWithKeyValuesArray:commentData[@"rsm"]]);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(@[]);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(commentData[@"err"]);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getArticleDataWithID:(NSString *)aid success:(void (^)(ArticleInfo *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id": aid,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs articleDetail] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *artData = (NSDictionary *)responseObject;
        if ([artData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ArticleInfo *articleData = [ArticleInfo mj_objectWithKeyValues:(artData[@"rsm"])[@"article_info"]];
                success(articleData);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(artData[@"err"]);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getArticleCommentWithID:(NSString *)aid page:(NSInteger)page success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id": aid,
                                 @"page": @(page),
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs articleComment] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *commentData = (NSDictionary *)responseObject;
        if ([commentData[@"errno"] isEqual:@1]) {
            id dataObj = (commentData[@"rsm"])[@"rows"];
            if ([dataObj isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success([CommentInfo mj_objectArrayWithKeyValuesArray: dataObj]);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(@[]);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(commentData[@"err"]);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

@end
