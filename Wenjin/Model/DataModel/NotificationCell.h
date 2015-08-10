//
//  NotificationCell.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/22.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Related.h"

@interface NotificationCell : NSObject

@property (nonatomic) NSInteger notificationId;
@property (nonatomic) NSInteger modelType;
@property (nonatomic) NSInteger actionType;
@property (nonatomic) NSInteger readFlag;
@property (nonatomic) NSInteger addTime;
@property (nonatomic) NSInteger anonymous;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *avatar;
@property (nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) Related *related;
@property (nonatomic) NSInteger keyUrl;
@property (strong, nonatomic) NSString *message;

@end
