//
//  AnswerInfo.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerInfo : NSObject

@property (nonatomic) NSInteger answerId;
@property (nonatomic) NSInteger questionId;
@property (strong, nonatomic) NSString *answerContent;
@property (nonatomic) NSInteger agreeCount;
@property (nonatomic) NSInteger agreeStatus;

@end
