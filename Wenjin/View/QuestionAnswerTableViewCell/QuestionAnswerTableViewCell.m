//
//  QuestionAnswerTableViewCell.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "QuestionAnswerTableViewCell.h"

@implementation QuestionAnswerTableViewCell

@synthesize userAvatarView;
@synthesize agreeCountLabel;
@synthesize userNameLabel;
@synthesize answerContentLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
