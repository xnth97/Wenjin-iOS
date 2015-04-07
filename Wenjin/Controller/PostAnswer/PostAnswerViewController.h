//
//  PostAnswerViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostAnswerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *answerView;

@property (strong, nonatomic) NSString *questionId;

@end
