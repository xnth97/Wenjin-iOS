//
//  AnswerDataManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnswerInfo.h"
#import "ArticleInfo.h"

@interface DetailDataManager : NSObject

+ (void)getAnswerDataWithAnswerID:(NSString *)answerId success:(void(^)(AnswerInfo *answerData))success failure:(void(^)(NSString *errorStr))failure;
+ (void)getAnswerCommentWithAnswerID:(NSString *)answerId success:(void(^)(NSArray *commentData))success failure:(void(^)(NSString *errorStr))failure;

+ (void)getArticleDataWithID:(NSString *)aid success:(void(^)(ArticleInfo *articleData))success failure:(void(^)(NSString *errorStr))failure;
+ (void)getArticleCommentWithID:(NSString *)aid page:(NSInteger)page success:(void(^)(NSArray *commentData))success failure:(void(^)(NSString *errorStr))failure;

@end
