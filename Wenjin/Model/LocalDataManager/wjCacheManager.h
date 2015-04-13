//
//  wjCacheManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface wjCacheManager : NSObject

+ (void)saveCacheData:(id)cacheData withKey:(NSString *)keyStr;
+ (void)loadCacheDataWithKey:(NSString *)keyStr andBlock:(void(^)(id cacheData, NSDate *saveDate))block;
+ (void)removeCacheDataForKey:(NSString *)keyStr;
+ (BOOL)cacheDataExistsWithKey:(NSString *)keyStr;

+ (void)saveCacheImage:(UIImage *)kImage withKey:(NSString *)keyStr;

@end
