//
//  data.h
//  Wenjin
//
//  Created by Qin Yubo on 13-10-13.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface data : NSObject

// for posting questions
@property (strong, nonatomic) NSAttributedString *postQuestionDetail;

// user information
@property (strong, nonatomic) NSString *myUID;
@property (strong, nonatomic) NSDictionary *myInfo;

@property (strong, nonatomic) NSString *attachAccessKey;

+ (data *)shareInstance;
+ (NSString *)appVersion;
+ (NSString *)appBuild;
+ (NSString *)osVersion;

@end
