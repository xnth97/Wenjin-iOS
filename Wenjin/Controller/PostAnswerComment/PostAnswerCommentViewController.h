//
//  PostAnswerCommentViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerCommentTableViewController.h"

@interface PostAnswerCommentViewController : UIViewController

@property (strong, nonatomic) UITextView *commentTextView;
@property (nonatomic) NSString *answerId;
@property (nonatomic) NSString *replyText;
@property (nonatomic) DetailType detailType;

@end
