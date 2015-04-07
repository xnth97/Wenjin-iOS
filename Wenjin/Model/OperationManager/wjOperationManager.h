//
//  wjOperationManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/7.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjOperationManager : NSObject

+ (void)followQuestionWithQuestionID:(NSString *)questionId success:(void(^)(NSString *operationType))success failure:(void(^)(NSString *errStr))failure;
+ (void)voteAnswerWithAnswerID:(NSString *)answerId operation:(NSInteger)operation success:(void(^)())success failure:(void(^)(NSString *errStr))failure;
+ (void)followPeopleWithUserID:(NSString *)uid success:(void(^)(NSString *operationType))success failure:(void(^)(NSString *errStr))failure;

@end
