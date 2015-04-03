//
//  QuestionAnswerTableViewCell.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "QuestionAnswerTableViewCell.h"
#import "ALActionBlocks.h"
#import "UIImageView+AFNetworking.h"
#import "wjAPIs.h"

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

- (void)loadAvatarWithURL:(NSString *)urlStr {
    [userAvatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], urlStr]]];
    userAvatarView.layer.cornerRadius = userAvatarView.frame.size.width / 2;
    userAvatarView.clipsToBounds = YES;
}

@end
