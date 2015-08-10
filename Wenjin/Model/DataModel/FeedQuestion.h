//
//  FeedQuestion.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/22.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedQuestion : NSObject

@property (nonatomic) NSInteger feedId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *detail;
@property (nonatomic) NSInteger addTime;
@property (nonatomic) NSInteger focusCount;
@property (nonatomic) NSInteger answerCount;

@end
