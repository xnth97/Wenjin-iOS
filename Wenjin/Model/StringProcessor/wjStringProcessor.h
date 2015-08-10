//
//  wjStringProcessor.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjStringProcessor : NSObject

+ (NSString *)processAnswerDetailString:(NSString *)detailString;
+ (NSString *)getSummaryFromString:(NSString *)string lengthLimit:(NSInteger)limit;
+ (NSString *)filterHTMLWithString:(NSString *)s;
+ (NSString *)convertToBootstrapHTMLWithContent:(NSString *)contentStr;
+ (NSString *)convertToBootstrapHTMLWithExtraBlankLinesWithContent:(NSString *)contentStr;
+ (NSString *)convertToBootstrapHTMLWithTimeWithContent:(NSString *)contentStr andTimeStamp:(NSInteger)timeStamp;

@end
