//
//  AnswerInfo.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface AnswerInfo : NSObject

@property (nonatomic) NSInteger answerId;
@property (nonatomic) NSInteger questionId;
@property (strong, nonatomic) NSString *answerContent;
@property (nonatomic) NSInteger agreeCount;
@property (nonatomic) NSInteger agreeStatus;
@property (nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *avatarFile;
@property (strong, nonatomic) NSString *signature;
@property (nonatomic) NSInteger voteValue;
@property (nonatomic) NSInteger thankValue;
@property (nonatomic) NSInteger addTime;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic) NSInteger anonymous;
@property (nonatomic) NSInteger uninterested;
@property (strong, nonatomic) NSString *questionTitle;

@end
