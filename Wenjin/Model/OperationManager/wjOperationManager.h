//
//  wjOperationManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/7.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define VoteAnswerTypeThank @"thanks"
#define VoteAnswerTypeUninterested @"uninterested"

typedef NS_ENUM(NSInteger, VoteArticleRating) {
    VoteArticleRatingAgree = 1,
    VoteArticleRatingDisagree = -1,
    VoteArticleRatingCancel = 0
};

@interface wjOperationManager : NSObject

/**
 *  关注问题
 *
 *  @param questionId 问题 ID
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)followQuestionWithQuestionID:(NSString *)questionId success:(void(^)(NSString *operationType))success failure:(void(^)(NSString *errStr))failure;

/**
 *  关注用户
 *
 *  @param uid     用户 ID
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)followPeopleWithUserID:(NSString *)uid success:(void(^)(NSString *operationType))success failure:(void(^)(NSString *errStr))failure;

/**
 *  关注话题
 *
 *  @param topicId 话题 ID
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)followTopicWithTopicID:(NSString *)topicId success:(void(^)(NSString *operationType))success failure:(void(^)(NSString *errStr))failure;

/**
 *  为答案投票
 *
 *  @param answerId  答案 ID
 *  @param operation 操作代码，1为赞同，-1为反对
 *  @param success   成功后回调
 *  @param failure   失败后回调
 */
+ (void)voteAnswerWithAnswerID:(NSString *)answerId operation:(NSInteger)operation success:(void(^)())success failure:(void(^)(NSString *errStr))failure;

+ (void)thankAnswerOrUninterestedWithAnswerID:(NSString *)answerId voteAnswerType:(NSString *)thankOrUninterested success:(void(^)())success failure:(void(^)(NSString *errStr))failure;

+ (void)voteArticleWithArticleID:(NSString *)articleId rating:(VoteArticleRating)rating success:(void(^)())success failure:(void(^)(NSString *errStr))failure;

@end
