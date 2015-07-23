//
//  wjAccountManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjAccountManager : NSObject

/**
 *  登录问津
 *
 *  @param parameters 结构化登录数据字典
 *  @param success    成功后回调（用户 id，用户名，头像）
 *  @param failure    失败后回调
 */
+ (void)loginWithParameters:(NSDictionary *)parameters success:(void(^)(NSString *uid, NSString *user_name, NSString *avatar_file))success failure:(void(^)(NSString *errStr))failure;

+ (void)logout;
+ (BOOL)userIsLoggedIn;

+ (void)profileSettingWithUID:(NSString *)uid nickName:(NSString *)nickName signature:(NSString *)signature birthday:(NSDate *)birthday success:(void(^)())success failure:(void(^)(NSString *errorStr))failure;
+ (void)uploadAvatar:(id)avatarFile success:(void(^)())success failure:(void(^)(NSString *errorStr))failure;

@end
