//
//  wjAccountManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "wjAccountManager.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "wjAPIs.h"
#import "wjCookieManager.h"

@implementation wjAccountManager

+ (void)loginWithParameters:(NSDictionary *)parameters success:(void (^)(NSString *, NSString *, NSString *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[wjAPIs login] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *loginData = [operation.responseString objectFromJSONString];
        if ([loginData[@"errno"] isEqual: @1]) {
            NSDictionary *userData = loginData[@"rsm"];
            NSString *uid = userData[@"uid"];
            NSString *user_name = userData[@"user_name"];
            NSString *avatar_file = userData[@"avatar_file"];
            success(uid, user_name, avatar_file);
            [wjCookieManager saveCookieForURLString:[wjAPIs login] andKey:@"login"];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userIsLoggedIn"];
            // save userdata to local cache.
        } else {
            failure(loginData[@"err"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (BOOL)userIsLoggedIn {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userIsLoggedIn"] == nil) {
        return NO;
    } else {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"userIsLoggedIn"];
    }
}

@end
