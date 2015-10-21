//
//  TopicBestAnswerViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/15.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableViewCell.h"

@interface TopicViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, homeTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *topicHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *topicImage;
@property (weak, nonatomic) IBOutlet UILabel *topicTitle;
@property (weak, nonatomic) IBOutlet UILabel *topicDescription;
@property (weak, nonatomic) IBOutlet UIButton *focusTopic;
@property (weak, nonatomic) IBOutlet UITableView *bestAnswerTableView;

@property (strong, nonatomic) NSString *topicId;
@property (nonatomic) BOOL topicFollowed;

- (IBAction)followTopic;

@end
