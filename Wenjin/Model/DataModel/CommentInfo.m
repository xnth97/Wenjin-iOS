//
//  CommentInfo.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/22.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "CommentInfo.h"
#import "MJExtension.h"

@implementation CommentInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"commentId": @"id",
             @"uid": @"uid",
             @"userName": @"user_name",
             @"nickName": @"nick_name",
             @"content": @"content",
             @"addTime": @"add_time",
             @"atUid": @"at_user.uid",
             @"atUserName": @"at_user.user_name",
             @"atNickName": @"at_user.nick_name",
             @"artComContent": @"message",
             @"artComNickName": @"user_info.nick_name",
             @"artComAvatarFile": @"user_info.avatar_file"};
}

@end
