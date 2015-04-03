//
//  wjAccountManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjAccountManager : NSObject

+ (void)loginWithParameters:(NSDictionary *)parameters success:(void(^)(NSString *uid, NSString *user_name, NSString *avatar_file))success failure:(void(^)(NSString *errStr))failure;
+ (void)logout;
+ (BOOL)userIsLoggedIn;

@end
