//
//  PostDataManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostDataManager : NSObject

/**
 *  提交问题
 *
 *  @param parameters 包含问题数据的参数字典
 *  @param success    成功后回调
 *  @param failure    失败后回调
 */
+ (void)postQuestionWithParameters:(NSDictionary *)parameters success:(void(^)(NSString *questionId))success failure:(void(^)(NSString *errorString))failure;

/**
 *  提交答案
 *
 *  @param parameters 包含答案数据的字典
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)postAnswerWithParameters:(NSDictionary *)parameters success:(void(^)(NSString *answerId))success failure:(void(^)(NSString *errStr))failure;


+ (void)postAnswerCommentWithAnswerID:(NSString *)answerId andMessage:(NSString *)message success:(void(^)())success failure:(void(^)(NSString *errorStr))failure;

+ (void)uploadAttachFromAttributedString:(NSAttributedString *)attrStr withAttachType:(NSString *)type;
+ (NSString *)plainStringConvertedFromAttributedString:(NSAttributedString *)attrStr andAttachIDArray:(NSArray *)attachIDArr;

/**
 *  提交附件
 *
 *  @param file    附件文件
 *  @param type    附件类型（评论，回答等）
 *  @param success 成功回调，返回 attachId
 *  @param failure 失败回调
 */
+ (void)uploadAttachFile:(id)file attachType:(NSString *)type success:(void(^)(NSString *attachId))success failure:(void(^)(NSString *errStr))failure;

+ (void)postFeedbackWithTitle:(NSString *)title message:(NSString *)message success:(void(^)())success failure:(void(^)(NSString *errorStr))failure;

+ (void)postArticleCommentWithArticleID:(NSString *)articleId andMessage:(NSString *)message success:(void(^)())success failure:(void(^)(NSString *errorStr))failure;

@end
