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
#import "data.h"

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

+ (void)postAnswerWithParameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[wjAPIs postAnswer] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObj) {
        
        NSDictionary *pqDic = [operation.responseString objectFromJSONString];
        if ([pqDic[@"errno"] isEqual: @1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success((pqDic[@"rsm"])[@"answer_id"]);
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

+ (void)postAnswerCommentWithAnswerID:(NSString *)answerId andMessage:(NSString *)message success:(void (^)())success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *getURLString = [NSString stringWithFormat:@"%@?answer_id=%@", [wjAPIs postAnswerComment], answerId];
    NSDictionary *parameters = @{@"message": message};
    [manager POST:getURLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicData = [operation.responseString objectFromJSONString];
        if ([dicData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
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

+ (void)uploadAttachFile:(id)file attachType:(NSString *)type success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    // Type = question, article, answer
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@&id=%@&attach_access_key=%@", [wjAPIs uploadAttach], type, [data shareInstance].attachAccessKey];
    
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:file name:@"qqfile" fileName:@"img.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicData = [operation.responseString objectFromJSONString];
        if ([dicData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success((dicData[@"rsm"])[@"attach_id"]);
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

+ (void)postFeedbackWithTitle:(NSString *)title message:(NSString *)message success:(void (^)())success failure:(void (^)(NSString *))failure {
    NSDictionary *parameters = @{@"title": title,
                                 @"message": message,
                                 @"version": [data appVersion],
                                 @"system": [data osVersion],
                                 @"source": @"ios"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[wjAPIs feedback] parameters:parameters success:^(AFHTTPRequestOperation *operation, id robj) {
        NSDictionary *dicData = [operation.responseString objectFromJSONString];
        if ([dicData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
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
