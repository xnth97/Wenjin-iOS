//
//  TWTDataChecker.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "TWTDataChecker.h"

@implementation TWTDataChecker

+ (BOOL)checkDataCompletion:(id)data {
    if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSMutableArray class]]) {
        NSArray *dataArr = (NSArray *)data;
        if (dataArr == 0) {
            return NO;
        } else {
//            for (id tmp in dataArr) {
//                
//            }
            return YES;
        }
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = (NSDictionary *)data;
        for (NSString *tmpKey in [dataDic allKeys]) {
            id tmpObj = dataDic[tmpKey];
            if (![self checkDataCompletion:tmpObj]) {
                return NO;
            }
        }
        return YES;
    } else {
        // To be completed...
        return YES;
    }
}

@end
