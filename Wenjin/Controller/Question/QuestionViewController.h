//
//  QuestionViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionHeaderView.h"

@interface QuestionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NSString *questionId;

@property (retain, nonatomic) IBOutlet UITableView *questionTableView;

@end
