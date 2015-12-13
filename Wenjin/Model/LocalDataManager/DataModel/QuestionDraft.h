//
//  QuestionDraft.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/4.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionDraft : NSObject

@property (strong, nonatomic) NSString *questionTitle;
@property (strong, nonatomic) NSData *questionDetail;
@property (strong, nonatomic) NSData *topicArrData;
@property (strong, nonatomic) NSString *attachAccessKey;
@property (nonatomic) NSInteger anonymous;
@property (strong, nonatomic) NSDate *time;

@end
