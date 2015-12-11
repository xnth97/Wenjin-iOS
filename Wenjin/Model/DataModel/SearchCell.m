//
//  SearchCell.m
//  Wenjin
//
//  Created by Qin Yubo on 15/10/20.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import "SearchCell.h"
#import "MJExtension.h"

@implementation SearchCell

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    return [propertyName mj_underlineFromCamel];
}

@end
