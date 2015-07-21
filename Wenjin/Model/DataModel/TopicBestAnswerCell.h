//
//  TopicBestAnswerCell.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/22.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionInfo.h"
#import "AnswerInfo.h"

@interface TopicBestAnswerCell : NSObject

@property (strong, nonatomic) QuestionInfo *questionInfo;
@property (strong, nonatomic) AnswerInfo *answerInfo;

@end
