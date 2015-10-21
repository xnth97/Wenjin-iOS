//
//  UserInfo.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *avatarFile;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *signature;
@property (nonatomic) NSInteger sex;
@property (nonatomic) NSInteger fansCount;
@property (nonatomic) NSInteger friendCount;
@property (nonatomic) NSInteger questionCount;
@property (nonatomic) NSInteger answerCount;
@property (nonatomic) NSInteger topicFocusCount;
@property (nonatomic) NSInteger agreeCount;
@property (nonatomic) NSInteger thanksCount;
@property (nonatomic) NSInteger reputation;
@property (nonatomic) NSInteger integral;
@property (nonatomic) NSInteger hasFocus;

@end