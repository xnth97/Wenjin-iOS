//
//  HomeCell.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "UserInfo.h"
#import "TopicInfo.h"
#import "AnswerInfo.h"
#import "QuestionInfo.h"
#import "ArticleInfo.h"

@interface HomeCell : NSObject

@property (nonatomic) NSInteger historyId;
@property (nonatomic) NSInteger uid;
@property (nonatomic) NSInteger associateAction;
@property (nonatomic) NSInteger associateId;
@property (nonatomic) NSInteger addTime;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) TopicInfo *topicInfo;
@property (strong, nonatomic) AnswerInfo *answerInfo;
@property (strong, nonatomic) QuestionInfo *questionInfo;
@property (strong, nonatomic) ArticleInfo *articleInfo;

@end
