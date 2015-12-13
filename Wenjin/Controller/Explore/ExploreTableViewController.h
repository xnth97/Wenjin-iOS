//
//  ExploreTableViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/12.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableViewCell.h"

@interface ExploreTableViewController : UITableViewController<homeTableViewCellDelegate>

@property (strong, nonatomic) NSString *expType;

@end
