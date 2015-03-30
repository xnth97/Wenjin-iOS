//
//  HomeDataManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDataManager : NSObject

+ (void)getHomeDataWithPage:(NSInteger)page success:(void(^)(NSArray *data, BOOL isLastPage))success failure:(void(^)(NSString *errStr))failure;

@end
