//
//  NotificationManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

+ (void)getUnreadNotificationNumberWithSuccess:(void(^)(NSUInteger inboxNum, NSUInteger notificationNum))success failure:(void(^)(NSString *errStr))failure;

@end
