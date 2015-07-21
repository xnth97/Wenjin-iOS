//
//  ExploreCell.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/21.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "ExploreCell.h"
#import "MJExtension.h"

@implementation ExploreCell

+ (NSString *)replacedKeyFromPropertyName121:(NSString *)propertyName {
    return [propertyName underlineFromCamel];
}

+ (NSDictionary *)objectClassInArray {
    return @{@"answer_users": @"AnswerInfo",
             @"topics": @"TopicInfo"};
}

@end
