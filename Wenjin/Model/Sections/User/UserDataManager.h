//
//  UserDataManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/2.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject

+ (void)getUserDataWithID:(NSString *)uid success:(void(^)(NSDictionary *userData))success failure:(void(^)(NSString *errStr))failure;
// operation = 0: 我关注的；1：关注我的
+ (void)getFollowUserListWithOperation:(NSInteger)operation userID:(NSString *)uid andPage:(NSInteger)page success:(void(^)(NSUInteger totalRows, NSArray *rowsData))success failure:(void(^)(NSString *errStr))failure;

@end
