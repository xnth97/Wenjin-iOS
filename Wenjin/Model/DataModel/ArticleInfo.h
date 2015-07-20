//
//  ArticleInfo.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/20.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleInfo : NSObject

@property (nonatomic) NSInteger aid;
@property (strong, nonatomic) NSString *title;
@property (nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *message;
@property (nonatomic) NSInteger votes;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *avatarFile;
@property (strong, nonatomic) NSString *signature;
@property (nonatomic) NSInteger voteValue;

@end
