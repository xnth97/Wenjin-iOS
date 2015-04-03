//
//  QuestionAnswerTableViewCell.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "QuestionAnswerTableViewCell.h"
#import "ALActionBlocks.h"

@implementation QuestionAnswerTableViewCell

@synthesize userAvatarView;
@synthesize agreeCountLabel;
@synthesize userNameLabel;
@synthesize answerContentLabel;

@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *userAvatarRecognizer = [[UITapGestureRecognizer alloc]initWithBlock:^(id weakSender) {
        UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)weakSender;
        [delegate pushUserControllerWithRow:tapRecognizer.view.tag];
    }];
    [userAvatarRecognizer setNumberOfTapsRequired:1];
    [userAvatarRecognizer setDelegate:self];
    [userAvatarView setUserInteractionEnabled:YES];
    [userAvatarView addGestureRecognizer:userAvatarRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
