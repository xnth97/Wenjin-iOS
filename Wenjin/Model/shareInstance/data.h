//
//  data.h
//  Wenjin
//
//  Created by Qin Yubo on 13-10-13.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface data : NSObject

// for posting questions
@property (strong, nonatomic) NSString *postQuestionDetail;
@property (strong, nonatomic) NSArray *postQuestionTopics;

@property (strong, nonatomic) NSString *myUID;

+ (data *)shareInstance;

@end
