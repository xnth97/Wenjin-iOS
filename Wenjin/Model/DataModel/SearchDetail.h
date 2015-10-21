//
//  SearchDetail.h
//  Wenjin
//
//  Created by Qin Yubo on 15/10/20.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDetail : NSObject

// Question

@property (nonatomic) NSInteger bestAnswer;
@property (nonatomic) NSInteger answerCount;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic) NSInteger focusCount;
@property (nonatomic) NSInteger agreeCount;

// Topic

@property (strong, nonatomic) NSString *topicPic;
@property (nonatomic) NSInteger topicId;
// Also focusCount
@property (nonatomic) NSInteger discussCount;
@property (strong, nonatomic) NSString *topicDescription;

// User

@property (strong, nonatomic) NSString *avatarFile;
@property (strong, nonatomic) NSString *signature;
@property (nonatomic) NSInteger reputation;
// Also agreeCount
@property (nonatomic) NSInteger thanksCount;
@property (nonatomic) NSInteger fansCount;

@end
