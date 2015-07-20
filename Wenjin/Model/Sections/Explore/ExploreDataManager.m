//
//  ExploreDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "ExploreDataManager.h"
#import "AFNetworking.h"
#import "wjAPIs.h"

@implementation ExploreDataManager

+ (void)getExploreDataWithPage:(NSUInteger)page isRecommended:(NSInteger)recommended sortType:(NSString *)type success:(void (^)(BOOL, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"page": [NSNumber numberWithInteger:page],
                                 @"day": @30,
                                 @"is_recommend": [NSNumber numberWithInteger:recommended],
                                 @"sort_type": type,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs explore] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            NSInteger totalRows = [(dicData[@"rsm"])[@"total_rows"] integerValue];
            if (totalRows != 0) {
                NSArray *rowsData = (dicData[@"rsm"])[@"rows"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(NO, rowsData);
                });
            } else {
                NSArray *rowsData = @[];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(YES, rowsData);
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
