//
//  UserFeedTableViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableViewCell.h"
#import "UserDataManager.h"
#import "UIScrollView+EmptyDataSet.h"

@interface UserFeedTableViewController : UITableViewController<homeTableViewCellDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic) UserFeedType feedType;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userAvatar;

@end
