//
//  QuestionDataManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionInfo.h"
#import "AnswerInfo.h"
#import "TopicInfo.h"
#import "MJExtension.h"

@interface QuestionDataManager : NSObject

+ (void)getQuestionDataWithID:(NSString *)questionId success:(void(^)(QuestionInfo *info, NSArray *answers, NSArray *topics, NSString *answerCount))success failure:(void(^)(NSString *errorStr))failure;

@end
