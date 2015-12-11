//
//  ArticleInfo.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/20.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "ArticleInfo.h"
#import "MJExtension.h"

@implementation ArticleInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"aid": @"id",
             @"title": @"title",
             @"message": @"message",
             @"votes": @"votes",
             @"userName": @"user_name",
             @"nickName": @"nick_name",
             @"avatarFile": @"avatar_file",
             @"signature": @"signature",
             @"voteValue": @"vote_value"};
}

@end
