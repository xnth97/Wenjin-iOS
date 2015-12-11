//
//  Notification.m
//  Wenjin
//
//  Created by Qin Yubo on 15/10/21.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import "Notification.h"
#import "MJExtension.h"

@implementation Notification

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"relatedId": @"id",
             @"nid": @"nid",
             @"type": @"type",
             @"alert": @"aps.alert",
             @"url": @"url"};
}

@end
