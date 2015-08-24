//
//  AnswerViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DetailType) {
    DetailTypeAnswer = 0,
    DetailTypeArticle = 1,
};

@interface DetailViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSString *answerId;
@property (nonatomic) DetailType detailType;

- (IBAction)pushCommentViewController;
- (IBAction)pushQuestionViewController;

@end
