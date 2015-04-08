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

@implementation UserDataManager

+ (void)getUserDataWithID:(NSString *)uid success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid};
    [manager GET:[wjAPIs viewUser] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *userDic = [operation.responseString objectFromJSONString];
        if ([userDic[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(userDic[@"rsm"]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(userDic[@"err"]);
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getFollowUserListWithOperation:(NSInteger)operation userID:(NSString *)uid andPage:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"page": [NSNumber numberWithInteger:page]};
    NSString *queueURL = (operation == 0) ? [wjAPIs myFollowUser] : [wjAPIs myFansUser];
    [manager GET:queueURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dicData = [operation.responseString objectFromJSONString];
        if ([dicData[@"errno"] isEqual:@1]) {
            NSInteger totalRows = [(dicData[@"rsm"])[@"total_rows"] integerValue];
            NSArray *rowsData = (dicData[@"rsm"])[@"rows"];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(totalRows, rowsData);
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

+ (void)getFansUserListWithUserID:(NSString *)uid andPage:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    
}

@end
