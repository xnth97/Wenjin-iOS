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
+ (void)postAnswerCommentWithAnswerID:(NSString *)answerId andMessage:(NSString *)message success:(void(^)())success failure:(void(^)(NSString *errorStr))failure;

+ (void)uploadAttachFile:(id)file attachType:(NSString *)type success:(void(^)(NSString *attachId))success failure:(void(^)(NSString *errStr))failure;

+ (void)postFeedbackWithTitle:(NSString *)title message:(NSString *)message success:(void(^)())success failure:(void(^)(NSString *errorStr))failure;

@end
