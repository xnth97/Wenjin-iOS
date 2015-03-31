//
//  PostViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *questionView;

- (IBAction)postQuestion;

@end
