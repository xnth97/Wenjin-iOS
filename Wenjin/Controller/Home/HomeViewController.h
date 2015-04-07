//
//  HomeViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/28.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableViewCell.h"

@interface HomeViewController : UITableViewController<homeTableViewCellDelegate>

@property (nonatomic) BOOL shouldRefresh;

@end
