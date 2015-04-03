//
//  PostDataManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostDataManager : NSObject

+ (void)postQuestionWithParameters:(NSDictionary *)parameters success:(void(^)(NSString *questionId))success failure:(void(^)(NSString *errorString))failure;
+ (void)postAnswerWithParameters:(NSDictionary *)parameters success:(void(^)(NSString *answerId))success failure:(void(^)(NSString *errStr))failure;

@end
