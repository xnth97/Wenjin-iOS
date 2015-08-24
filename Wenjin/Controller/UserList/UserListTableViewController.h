//
//  UserListTableViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface UserListTableViewController : UITableViewController <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic) NSInteger userType;
@property (nonatomic) NSString *userId;

@end
