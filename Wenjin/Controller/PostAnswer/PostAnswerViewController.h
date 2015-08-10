//
//  PostAnswerViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDraft.h"

@interface PostAnswerViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UITextView *answerView;
@property (strong, nonatomic) NSString *questionId;
@property (strong, nonatomic) AnswerDraft *draftToBeLoaded;

@end
