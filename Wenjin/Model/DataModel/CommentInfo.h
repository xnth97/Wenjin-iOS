//
//  CommentInfo.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/22.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property (nonatomic) NSInteger commentId;
@property (nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *content;
@property (nonatomic) NSInteger addTime;
@property (nonatomic) NSInteger atUid;
@property (strong, nonatomic) NSString *atUserName;
@property (strong, nonatomic) NSString *atNickName;
@property (strong, nonatomic) NSString *artComContent;
@property (strong, nonatomic) NSString *artComNickName;
@property (strong, nonatomic) NSString *artComAvatarFile;

@end
