//
//  AnswerDraft.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/4.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerDraft : NSObject

@property (strong, nonatomic) NSString *questionId;
@property (strong, nonatomic) NSData *answerContent;
@property (strong, nonatomic) NSString *attachAccessKey;
@property (nonatomic) NSInteger anonymous;
@property (strong, nonatomic) NSDate *time;

@end