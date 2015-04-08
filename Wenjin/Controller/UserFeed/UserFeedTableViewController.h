//
//  UserFeedTableViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableViewCell.h"

@interface UserFeedTableViewController : UITableViewController<homeTableViewCellDelegate>

@property (nonatomic) NSInteger feedType;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userAvatar;

@end
