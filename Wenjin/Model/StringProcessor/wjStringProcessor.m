//
//  wjStringProcessor.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "wjStringProcessor.h"

@implementation wjStringProcessor

+ (NSString *)processAnswerDetailString:(NSString *)detailString {
    detailString = [self filterHTMLWithString:detailString];
    return ([detailString hasPrefix:@"<img src="]) ? @"[图片]" : (([detailString length] > 60) ? [NSString stringWithFormat:@"%@...", [detailString substringToIndex:61]] : detailString);
}

+ (NSString *)filterHTMLWithString:(NSString *)s {
    s = [s stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    s = [s stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    s = [s stringByReplacingOccurrencesOfString:@"[quote]" withString:@"[引用]"];
    s = [s stringByReplacingOccurrencesOfString:@"[/quote]" withString:@""];
    return s;
}

@end
