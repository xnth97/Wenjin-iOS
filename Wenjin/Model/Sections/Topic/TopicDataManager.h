//
//  TopicDataManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/10.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicInfo.h"

@interface TopicDataManager : NSObject

// topic type: today, hot, focus
+ (void)getTopicListWithType:(NSString *)topicType andPage:(NSInteger)page success:(void(^)(NSUInteger totalRows, NSArray *rowsData))success failure:(void(^)(NSString *errStr))failure;
+ (void)getTopicInfoWithTopicID:(NSString *)topicID userID:(NSString *)uid success:(void(^)(TopicInfo *topicInfo))success failure:(void(^)(NSString *errStr))failure;
+ (void)getTopicBestAnswerWithTopicID:(NSString *)topicId page:(NSInteger)page success:(void(^)(NSUInteger totalRows, NSArray *rowsData))success failure:(void(^)(NSString *errStr))failure;

@end
