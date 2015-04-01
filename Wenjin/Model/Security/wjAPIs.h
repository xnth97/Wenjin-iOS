//
//  wjAPIs.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjAPIs : NSObject

+ (NSString *)login;
+ (NSString *)avatarPath;

// 动态首页
+ (NSString *)homeURL;

// 发布问题
+ (NSString *)postQuestion;

// 阅读问题
+ (NSString *)viewQuestion;

// 阅读答案
+ (NSString *)viewAnswer;

@end
