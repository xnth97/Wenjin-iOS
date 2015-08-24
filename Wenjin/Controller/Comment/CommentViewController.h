//
//  AnswerCommentTableViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "SLKTextViewController.h"

@interface CommentViewController : SLKTextViewController

@property (nonatomic) NSString *answerId;
@property (nonatomic) DetailType detailType;

@end
