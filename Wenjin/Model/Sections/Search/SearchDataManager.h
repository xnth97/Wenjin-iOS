//
//  SearchDataManager.h
//  Wenjin
//
//  Created by Qin Yubo on 15/10/20.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDataManager : NSObject

+ (void)getSearchDataWithQuery:(NSString *)queryStr type:(NSInteger)type page:(NSInteger)page success:(void(^)(NSArray *rowsData))success failure:(void(^)(NSString *errorStr))failure;

@end
