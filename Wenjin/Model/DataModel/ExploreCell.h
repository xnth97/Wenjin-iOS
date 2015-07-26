//
//  ExploreCell.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/21.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicInfo.h"
#import "UserInfo.h"
#import "AnswerInfo.h"

@interface ExploreCell : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger questionId;
@property (strong, nonatomic) NSString *questionContent;
@property (strong, nonatomic) NSString *title;
@property (nonatomic) NSInteger addTime;
@property (nonatomic) NSInteger updateTime;
@property (nonatomic) NSInteger publishedUid;
@property (nonatomic) NSInteger answerCount;
@property (strong, nonatomic) NSArray *answerUsers;
@property (nonatomic) NSInteger viewCount;
@property (nonatomic) NSInteger focusCount;
@property (nonatomic) NSInteger anonymous;
@property (strong, nonatomic) NSString *postType;
@property (strong, nonatomic) NSArray *topics;
@property (strong, nonatomic) UserInfo *userInfo;

@end
