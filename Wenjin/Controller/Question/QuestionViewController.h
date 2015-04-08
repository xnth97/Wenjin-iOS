//
//  QuestionViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionHeaderView.h"
#import "QuestionAnswerTableViewCell.h"

@interface QuestionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, QuestionCellPushUserDelegate, QuestionHeaderViewDelegate>

@property (strong, nonatomic) NSString *questionId;

@property (weak, nonatomic) IBOutlet UITableView *questionTableView;

@property (nonatomic) BOOL shouldRefresh;

@end
