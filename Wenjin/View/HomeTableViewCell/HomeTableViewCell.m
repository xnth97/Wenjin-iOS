//
//  HomeTableViewCell.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

@synthesize actionLabel;
@synthesize questionLabel;
@synthesize detailLabel;

@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *userTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userAction:)];
    [userTapRecognizer setNumberOfTapsRequired:1];
    [userTapRecognizer setDelegate:self];
    actionLabel.userInteractionEnabled = YES;
    [actionLabel addGestureRecognizer:userTapRecognizer];
    
    UITapGestureRecognizer *titleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleAction:)];
    [titleTapRecognizer setNumberOfTapsRequired:1];
    [titleTapRecognizer setDelegate:self];
    questionLabel.userInteractionEnabled = YES;
    [questionLabel addGestureRecognizer:titleTapRecognizer];
    
    UITapGestureRecognizer *detailTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailAction:)];
    [detailTapRecognizer setNumberOfTapsRequired:1];
    [detailTapRecognizer setDelegate:self];
    detailLabel.userInteractionEnabled = YES;
    [detailLabel addGestureRecognizer:detailTapRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)userAction:(id)sender {
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    [delegate pushUserControllerWithRow:tapRecognizer.view.tag];
}

- (void)titleAction:(id)sender {
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    [delegate pushQuestionControllerWithRow:tapRecognizer.view.tag];
}

- (void)detailAction:(id)sender {
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    [delegate pushAnswerControllerWithRow:tapRecognizer.view.tag];
}

@end
