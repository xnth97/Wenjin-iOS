//
//  wjAPIs.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjAPIs : NSObject

+ (NSString *)baseURL;
+ (NSString *)login;


// 动态首页
+ (NSString *)homeURL;

// 发布问题
+ (NSString *)postQuestion;

// 添加答案
+ (NSString *)postAnswer;

// 阅读问题
+ (NSString *)viewQuestion;

// 阅读答案
+ (NSString *)viewAnswer;

// 查看用户
+ (NSString *)viewUser;

// 话题图片
+ (NSString *)topicImagePath;

// 头像图片
+ (NSString *)avatarPath;

// 回复图片
+ (NSString *)answerImagePath;

// 关注问题
+ (NSString *)followQuestion;

// 赞同答案
+ (NSString *)voteAnswer;

// 感谢答案 & 没有帮助
+ (NSString *)thankAnswerAndUninterested;

// 关注用户
+ (NSString *)followUser;

// 答案评论
+ (NSString *)answerComment;

// 我关注的用户
+ (NSString *)myFollowUser;

// 关注我的用户
+ (NSString *)myFansUser;

// 我的提问
+ (NSString *)myQuestions;

// 我的回答
+ (NSString *)myAnswers;

// 我的关注问题
+ (NSString *)myFollowQuestions;

// 我的关注话题
+ (NSString *)myFollowTopics;

// 发布答案评论
+ (NSString *)postAnswerComment;

// 话题列表
+ (NSString *)topicList;

// 话题详情
+ (NSString *)topicInfo;

// 话题精华
+ (NSString *)topicBestAnswer;

// 关注话题
+ (NSString *)followTopic;

// 文章详细
+ (NSString *)articleDetail;

// 文章评论
+ (NSString *)articleComment;

// 发表文章评论
+ (NSString *)postArticleComment;

// 文章点赞
+ (NSString *)voteArticle;

// 发现
+ (NSString *)explore;

// 传文件
+ (NSString *)uploadAttach;

// 反馈
+ (NSString *)feedback;

// 通知
+ (NSString *)notificationList;
+ (NSString *)readNotification;
+ (NSString *)notificationNumber;

// 修改用户信息
+ (NSString *)profileSetting;

// 修改用户头像
+ (NSString *)avatarUpload;

// 搜索
+ (NSString *)search;

// Bug HD Key
+ (NSString *)firKey;

// WeChat
+ (NSString *)wechatAppID;
+ (NSString *)wechatAppSecret;

@end
