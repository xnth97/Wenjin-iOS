//
//  FeedbackForm.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/20.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "FeedbackForm.h"
#import "data.h"

@implementation FeedbackForm

- (NSArray *)fields {
    return @[
             
             @{FXFormFieldKey: @"title", FXFormFieldTitle: @"反馈问题", FXFormFieldHeader: @"基本信息"},
             @{FXFormFieldKey: @"appVersion", FXFormFieldTitle: @"问津版本",  FXFormFieldDefaultValue: [data appVersion]},
             @{FXFormFieldKey: @"systemVersion", FXFormFieldTitle: @"iOS 版本", FXFormFieldDefaultValue: [data osVersion]},
             
             @{FXFormFieldKey: @"message", FXFormFieldTitle: @"", FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldHeader: @"反馈详情"}
             
             ];
}

- (NSDictionary *)titleField {
    return @{@"textField.textAlignment": @(NSTextAlignmentLeft),
             @"textLabel.font": [UIFont systemFontOfSize:17.0]};
}

- (NSDictionary *)appVersionField {
    return @{@"textField.textAlignment": @(NSTextAlignmentLeft),
             @"textField.userInteractionEnabled": @NO,
             @"textLabel.font": [UIFont systemFontOfSize:17.0]};
}

- (NSDictionary *)systemVersionField {
    return @{@"textField.textAlignment": @(NSTextAlignmentLeft),
             @"textField.userInteractionEnabled": @NO,
             @"textLabel.font": [UIFont systemFontOfSize:17.0]};
}

@end
