//
//  wjAccountManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "wjAccountManager.h"
#import "AFNetworking.h"
#import "wjAPIs.h"
#import "wjCookieManager.h"
#import "data.h"
#import "wjCacheManager.h"
#import "wjDatabaseManager.h"

@implementation wjAccountManager

+ (void)loginWithParameters:(NSDictionary *)parameters success:(void (^)(NSString *, NSString *, NSString *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@?platform=ios", [wjAPIs login]] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *loginData = (NSDictionary *)responseObject;
        if ([loginData[@"errno"] isEqual: @1]) {
            NSDictionary *userData = loginData[@"rsm"];
            NSString *uid = [userData[@"uid"] stringValue];
            NSString *user_name = userData[@"user_name"];
            NSString *avatar_file = userData[@"avatar_file"];
            
            [wjCookieManager saveCookieForURLString:[wjAPIs login] andKey:@"login"];
            [wjCacheManager saveCacheData:userData withKey:@"userData"];
            [wjCacheManager saveCacheData:parameters withKey:@"userLoginData"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userIsLoggedIn"];
            [data shareInstance].myUID = uid;
            success(uid, user_name, avatar_file);
            
            // save userdata to local cache.
        } else {
            failure(loginData[@"err"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (void)logout {
    [wjCookieManager removeCookieForKey:@"login"];
    [wjCacheManager removeCacheDataForKey:@"homeCache"];
    [wjCacheManager removeCacheDataForKey:@"userData"];
    [wjCacheManager removeCacheDataForKey:@"userLoginData"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userIsLoggedIn"];
    [wjDatabaseManager removeDatabase];
}

+ (BOOL)userIsLoggedIn {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userIsLoggedIn"] == nil) {
        return NO;
    } else {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"userIsLoggedIn"];
    }
}

+ (void)profileSettingWithUID:(NSString *)uid nickName:(NSString *)nickName signature:(NSString *)signature birthday:(NSDate *)birthday success:(void (^)())success failure:(void (^)(NSString *))failure {
    NSDictionary *parameters = @{@"uid": uid,
                                 @"nick_name": nickName,
                                 @"signature": signature,
                                 @"birthday": [NSString stringWithFormat:@"%f", [birthday timeIntervalSince1970]]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[wjAPIs profileSetting] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"errno"] isEqual:@1]) {
            success();
        } else {
            failure(dic[@"err"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (void)uploadAvatar:(id)avatarFile success:(void (^)())success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[wjAPIs avatarUpload] parameters:@{@"platform": @"ios"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:avatarFile name:@"user_avatar" fileName:@"img.jpg" mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
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
