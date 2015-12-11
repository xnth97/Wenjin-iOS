//
//  SearchDataManager.m
//  Wenjin
//
//  Created by Qin Yubo on 15/10/20.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import "SearchDataManager.h"
#import "SearchCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "wjAPIs.h"

@implementation SearchDataManager

+ (void)getSearchDataWithQuery:(NSString *)queryStr type:(NSInteger)type page:(NSInteger)page success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"q": queryStr,
                                 @"type": (@[@"questions", @"topics", @"users"])[type],
                                 @"limit": @10,
                                 @"page": @(page),
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs search] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            NSArray *rowsData = [SearchCell mj_objectArrayWithKeyValuesArray:(dicData[@"rsm"])[@"info"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(rowsData);
            });
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
