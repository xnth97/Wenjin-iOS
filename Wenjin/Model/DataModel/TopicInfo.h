//
//  TopicInfo.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicInfo : NSObject

@property (nonatomic) NSInteger topicId;
@property (strong, nonatomic) NSString *topicTitle;
@property (strong, nonatomic) NSString *urlToken;
@property (strong, nonatomic) NSString *topicPic;
@property (strong, nonatomic) NSString *topicDescription;
@property (nonatomic) NSInteger focusCount;
@property (nonatomic) NSInteger hasFocus;

@end
