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

@implementation DetailDataManager

+ (void)getAnswerDataWithAnswerID:(NSString *)answerId success:(void (^)(AnswerInfo *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id": answerId,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs viewAnswer] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *ansData = (NSDictionary *)responseObject;
        if ([ansData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AnswerInfo *answerData = [AnswerInfo objectWithKeyValues:ansData[@"rsm"]];
                success(answerData);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(ansData[@"err"]);
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getAnswerCommentWithAnswerID:(NSString *)answerId success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id": answerId,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs answerComment] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *commentData = (NSDictionary *)responseObject;
        if ([commentData[@"errno"] isEqual:@1]) {
            id dataObj = commentData[@"rsm"];
            if ([dataObj isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(commentData[@"rsm"]);
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getArticleDataWithID:(NSString *)aid success:(void (^)(ArticleInfo *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id": aid,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs articleDetail] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *artData = (NSDictionary *)responseObject;
        if ([artData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ArticleInfo *articleData = [ArticleInfo objectWithKeyValues:(artData[@"rsm"])[@"article_info"]];
                success(articleData);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(artData[@"err"]);
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

@end
