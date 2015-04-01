//
//  HomeTableViewCell.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "ALActionBlocks.h"

@implementation HomeTableViewCell

@synthesize actionLabel;
@synthesize questionLabel;
@synthesize detailLabel;

@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *userTapRecognizer = [[UITapGestureRecognizer alloc]initWithBlock:^(id weakSender) {
        UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)weakSender;
        [delegate pushUserControllerWithRow:tapRecognizer.view.tag];
    }];
    [userTapRecognizer setNumberOfTapsRequired:1];
    [userTapRecognizer setDelegate:self];
    actionLabel.userInteractionEnabled = YES;
    [actionLabel addGestureRecognizer:userTapRecognizer];
    
    UITapGestureRecognizer *titleTapRecognizer = [[UITapGestureRecognizer alloc]initWithBlock:^(id weakSender) {
        UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)weakSender;
        [delegate pushQuestionControllerWithRow:tapRecognizer.view.tag];
    }];
    [titleTapRecognizer setNumberOfTapsRequired:1];
    [titleTapRecognizer setDelegate:self];
    questionLabel.userInteractionEnabled = YES;
    [questionLabel addGestureRecognizer:titleTapRecognizer];
    
    UITapGestureRecognizer *detailTapRecognizer = [[UITapGestureRecognizer alloc]initWithBlock:^(id weakSender) {
        UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)weakSender;
        [delegate pushAnswerControllerWithRow:tapRecognizer.view.tag];
    }];
    [detailTapRecognizer setNumberOfTapsRequired:1];
    [detailTapRecognizer setDelegate:self];
    detailLabel.userInteractionEnabled = YES;
    [detailLabel addGestureRecognizer:detailTapRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
