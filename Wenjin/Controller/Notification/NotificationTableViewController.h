//
//  NotificationTableViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NOTIFICATION_CLEAR_ALL @"notification_clear_all"
#define NOTIFICATION_REFRESH @"notification_refresh"

@interface NotificationTableViewController : UITableViewController

@property (nonatomic) BOOL notificationIsReadOrNot;

@end
