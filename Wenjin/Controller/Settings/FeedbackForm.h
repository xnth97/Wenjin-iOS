//
//  FeedbackForm.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/20.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface FeedbackForm : NSObject<FXForm>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *appVersion;
@property (copy, nonatomic) NSString *systemVersion;

@end
