//
//  UserDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/2.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "UserDataManager.h"
#import "AFNetworking.h"
#import "wjAPIs.h"
#import "data.h"
#import "wjCacheManager.h"
#import "MJExtension.h"
#import "AnswerInfo.h"
#import "FeedQuestion.h"
#import "TopicInfo.h"

#define MY_PROFILE_CACHE @"myProf"

@implementation UserDataManager

+ (void)getUserDataWithID:(NSString *)uid success:(void (^)(UserInfo *))success failure:(void (^)(NSString *))failure {
    if ([data shareInstance].myUID != nil) {
        if ([uid integerValue] == [[data shareInstance].myUID integerValue]) {
            [wjCacheManager loadCacheDataWithKey:MY_PROFILE_CACHE andBlock:^(id myProfileCache, NSDate *saveDate) {
                success([UserInfo mj_objectWithKeyValues:myProfileCache]);
            }];
        }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs viewUser] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *userDic = (NSDictionary *)responseObject;
        if ([userDic[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success([UserInfo mj_objectWithKeyValues:userDic[@"rsm"]]);
            });
            if ([uid integerValue] == [[data shareInstance].myUID integerValue]) {
                [wjCacheManager saveCacheData:userDic[@"rsm"] withKey:MY_PROFILE_CACHE];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(userDic[@"err"]);
            });
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)getFollowUserListWithOperation:(NSInteger)operation userID:(NSString *)uid andPage:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    NSString *queueURL = (operation == 0) ? [wjAPIs myFollowUser] : [wjAPIs myFansUser];
    [manager GET:queueURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            NSInteger totalRows = [(dicData[@"rsm"])[@"total_rows"] integerValue];
            if (totalRows != 0) {
                NSArray *rowsData = [UserInfo mj_objectArrayWithKeyValuesArray:(dicData[@"rsm"])[@"rows"]];
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
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getUserFeedWithType:(UserFeedType)feedType userID:(NSString *)uid page:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    NSArray *queueURLArray = @[[wjAPIs myQuestions], [wjAPIs myAnswers], [wjAPIs myFollowQuestions]];
    [manager GET:queueURLArray[feedType] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            NSInteger totalRows = [(dicData[@"rsm"])[@"total_rows"] integerValue];
            if (totalRows != 0) {
                NSArray *rawData = (dicData[@"rsm"])[@"rows"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (feedType == UserFeedTypeAnswer) {
                        success(totalRows, [AnswerInfo mj_objectArrayWithKeyValuesArray:rawData]);
                    } else {
                        success(totalRows, [FeedQuestion mj_objectArrayWithKeyValuesArray:rawData]);
                    }
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
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getFollowTopicListWithUserID:(NSString *)uid page:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs myFollowTopics] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            NSInteger totalRows = [(dicData[@"rsm"])[@"total_rows"] integerValue];
            if (totalRows != 0) {
                NSArray *rowsData = [TopicInfo mj_objectArrayWithKeyValuesArray:(dicData[@"rsm"])[@"rows"]];
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
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

@end
