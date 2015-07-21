//
//  QuestionInfo.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/11.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionInfo : NSObject

@property (nonatomic) NSInteger questionId;
@property (strong, nonatomic) NSString *questionContent;
@property (strong, nonatomic) NSString *questionDetail;
@property (nonatomic) NSInteger focusCount;
@property (nonatomic) NSInteger hasFocus;
@property (nonatomic) NSInteger publishedUid;
@property (nonatomic) NSInteger anonymous;

@end
