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

@end
