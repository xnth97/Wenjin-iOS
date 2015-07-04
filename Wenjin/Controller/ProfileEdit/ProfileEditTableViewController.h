//
//  ProfileEditTableViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface ProfileEditTableViewController : UITableViewController <FXFormControllerDelegate>

@property (strong, nonatomic) FXFormController *formController;

- (IBAction)submitInfo;

@end
