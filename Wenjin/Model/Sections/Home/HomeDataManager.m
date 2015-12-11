//
//  HomeDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "HomeDataManager.h"
#import "wjAPIs.h"
#import "wjCacheManager.h"
#import "AFNetworking.h"
#import "HomeCell.h"

@implementation HomeDataManager

+ (void)getHomeDataWithPage:(NSInteger)page success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSString *))failure {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *parameters = @{@"page": [NSNumber numberWithInteger:page],
                                 @"per_page": @20,
                                 @"platform": @"ios"};
    if (page == 0) {
//        [wjCacheManager loadCacheDataWithKey:@"homeCache" andBlock:^(NSArray *rows, NSDate *saveDate) {
//            if (rows != nil) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    success(rows, NO);
//                });
//            }
//        }];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[wjAPIs homeURL] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"errno"] isEqual: @1]) {
            NSArray *rows = [HomeCell mj_objectArrayWithKeyValuesArray:(responseDic[@"rsm"])[@"rows"]];
            if (page == 0) {
                //[wjCacheManager saveCacheData:rows withKey:@"homeCache"];
            }
            if ([(responseDic[@"rsm"])[@"total_rows"] isEqual: @0]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(rows, YES);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(rows, NO);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(responseDic[@"err"]);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

@end
