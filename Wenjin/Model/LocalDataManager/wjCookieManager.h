//
//  wjCookieManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjCookieManager : NSObject

+ (void)saveCookieForURLString:(NSString *)urlStr andKey:(NSString *)key;
+ (void)loadCookieForKey:(NSString *)key;
+ (void)removeCookieForKey:(NSString *)key;

@end
