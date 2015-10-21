//
//  FeedbackViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/20.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface FeedbackViewController : UITableViewController<FXFormControllerDelegate>

@property (strong, nonatomic) FXFormController *formController;

@end
