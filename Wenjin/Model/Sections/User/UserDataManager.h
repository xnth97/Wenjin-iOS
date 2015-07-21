//
//  UserDataManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/2.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

typedef NS_ENUM(NSInteger, UserFeedType) {
    UserFeedTypeQuestion = 0,
    UserFeedTypeAnswer = 1,
    UserFeedTypeFollowQuestion = 2,
};

@interface UserDataManager : NSObject

+ (void)getUserDataWithID:(NSString *)uid success:(void(^)(UserInfo *userData))success failure:(void(^)(NSString *errStr))failure;

// operation = 0: 我关注的；1：关注我的
+ (void)getFollowUserListWithOperation:(NSInteger)operation userID:(NSString *)uid andPage:(NSInteger)page success:(void(^)(NSUInteger totalRows, NSArray *rowsData))success failure:(void(^)(NSString *errStr))failure;

// feedType = 0：提问；1：回答；2：关注
+ (void)getUserFeedWithType:(UserFeedType)feedType userID:(NSString *)uid page:(NSInteger)page success:(void(^)(NSUInteger totalRows, NSArray *rowsData))success failure:(void(^)(NSString *errStr))failure;

+ (void)getFollowTopicListWithUserID:(NSString *)uid page:(NSInteger)page success:(void(^)(NSUInteger totalRows, NSArray *rowsData))success failure:(void(^)(NSString *errStr))failure;

@end
