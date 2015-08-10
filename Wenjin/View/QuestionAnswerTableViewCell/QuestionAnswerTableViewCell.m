//
//  QuestionAnswerTableViewCell.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "QuestionAnswerTableViewCell.h"
#import "BlocksKit+UIKit.h"
#import "UIImageView+AFNetworking.h"
#import "wjAppearanceManager.h"
#import "wjAPIs.h"

@implementation QuestionAnswerTableViewCell

@synthesize userAvatarView;
@synthesize agreeCountLabel;
@synthesize userNameLabel;
@synthesize answerContentLabel;

@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *userAvatarRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(id weakSender, UIGestureRecognizerState state, CGPoint location) {
        UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)weakSender;
        [delegate pushUserControllerWithRow:tapRecognizer.view.tag];
    }];
    [userAvatarRecognizer setNumberOfTapsRequired:1];
    [userAvatarRecognizer setDelegate:self];
    [userAvatarView setUserInteractionEnabled:YES];
    [userAvatarView addGestureRecognizer:userAvatarRecognizer];
    
    agreeCountLabel.backgroundColor = [wjAppearanceManager mainTintColor];
    agreeCountLabel.textColor = [UIColor whiteColor];
    agreeCountLabel.layer.cornerRadius = 8.0;
    agreeCountLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadAvatarWithURL:(NSString *)urlStr {
    [userAvatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], urlStr]] placeholderImage:[UIImage imageNamed:@"placeholderAvatar.png"]];
    userAvatarView.layer.cornerRadius = userAvatarView.frame.size.width / 2;
    userAvatarView.clipsToBounds = YES;
}

@end
