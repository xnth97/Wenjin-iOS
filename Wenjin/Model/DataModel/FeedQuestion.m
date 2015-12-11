//
//  FeedQuestion.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/22.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "FeedQuestion.h"
#import "MJExtension.h"

@implementation FeedQuestion

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"feedId": @"id",
             @"title": @"title",
             @"detail": @"detail",
             @"addTime": @"add_time",
             @"focusCount": @"focus_count",
             @"answerCount": @"answer_count"};
}

@end
