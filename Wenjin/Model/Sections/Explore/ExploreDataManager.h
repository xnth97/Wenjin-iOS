//
//  ExploreDataManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExploreDataManager : NSObject

+ (void)getExploreDataWithPage:(NSUInteger)page isRecommended:(NSInteger)recommended sortType:(NSString *)type success:(void(^)(BOOL isLastPage, NSArray *rowsData))success failure:(void(^)(NSString *errStr))failure;

@end
