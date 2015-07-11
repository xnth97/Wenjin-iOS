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

@end
