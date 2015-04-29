//
//  UserDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/2.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "UserDataManager.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "wjAPIs.h"
#import "data.h"
#import "wjCacheManager.h"

@implementation UserDataManager

+ (void)getUserDataWithID:(NSString *)uid success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
    if ([data shareInstance].myUID != nil) {
        if ([uid integerValue] == [[data shareInstance].myUID integerValue]) {
            [wjCacheManager loadCacheDataWithKey:@"myProfile" andBlock:^(id myProfileCache, NSDate *saveDate) {
                success(myProfileCache);
            }];
        }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs viewUser] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *userDic = [operation.responseString objectFromJSONString];
        if ([userDic[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(userDic[@"rsm"]);
            });
            if ([uid integerValue] == [[data shareInstance].myUID integerValue]) {
                [wjCacheManager saveCacheData:userDic[@"rsm"] withKey:@"myProfile"];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(userDic[@"err"]);
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

+ (void)getFollowUserListWithOperation:(NSInteger)operation userID:(NSString *)uid andPage:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    NSString *queueURL = (operation == 0) ? [wjAPIs myFollowUser] : [wjAPIs myFansUser];
    [manager GET:queueURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

+ (void)getUserFeedWithType:(NSInteger)feedType userID:(NSString *)uid page:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    NSArray *queueURLArray = @[[wjAPIs myQuestions], [wjAPIs myAnswers], [wjAPIs myFollowQuestions]];
    [manager GET:queueURLArray[feedType] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

+ (void)getFollowTopicListWithUserID:(NSString *)uid page:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs myFollowTopics] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
