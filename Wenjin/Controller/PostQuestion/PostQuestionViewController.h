//
//  PostViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostQuestionViewController : UIViewController

@property (strong, nonatomic) UITextView *questionView;

- (IBAction)postQuestion;
- (IBAction)cancelModal;

@end
