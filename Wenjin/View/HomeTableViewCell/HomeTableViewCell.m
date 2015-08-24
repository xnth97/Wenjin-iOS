//
//  HomeTableViewCell.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "HomeTableViewCell.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "wjAPIs.h"
#import "wjAppearanceManager.h"

@implementation HomeTableViewCell

@synthesize actionLabel;
@synthesize questionLabel;
@synthesize detailLabel;
@synthesize avatarView;

@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *userTapRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(id weakSender, UIGestureRecognizerState state, CGPoint location) {
        UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)weakSender;
        [delegate pushUserControllerWithRow:tapRecognizer.view.tag];
    }];
    [userTapRecognizer setNumberOfTapsRequired:1];
    [userTapRecognizer setDelegate:self];
    actionLabel.userInteractionEnabled = YES;
    [actionLabel addGestureRecognizer:userTapRecognizer];
    
    UITapGestureRecognizer *userTapRecognizer2 = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(id weakSender, UIGestureRecognizerState state, CGPoint location) {
        UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)weakSender;
        [delegate pushUserControllerWithRow:tapRecognizer.view.tag];
    }];
    [userTapRecognizer2 setNumberOfTapsRequired:1];
    [userTapRecognizer2 setDelegate:self];
    avatarView.userInteractionEnabled = YES;
    [avatarView addGestureRecognizer:userTapRecognizer2];
    
    UITapGestureRecognizer *titleTapRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(id weakSender, UIGestureRecognizerState state, CGPoint location) {
        UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)weakSender;
        [delegate pushQuestionControllerWithRow:tapRecognizer.view.tag];
    }];
    [titleTapRecognizer setNumberOfTapsRequired:1];
    [titleTapRecognizer setDelegate:self];
    questionLabel.userInteractionEnabled = YES;
    [questionLabel addGestureRecognizer:titleTapRecognizer];
    
    UITapGestureRecognizer *detailTapRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(id weakSender, UIGestureRecognizerState state, CGPoint location) {
        UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)weakSender;
        [delegate pushDetailControllerWithRow:tapRecognizer.view.tag];
    }];
    [detailTapRecognizer setNumberOfTapsRequired:1];
    [detailTapRecognizer setDelegate:self];
    detailLabel.userInteractionEnabled = YES;
    [detailLabel addGestureRecognizer:detailTapRecognizer];
    
    avatarView.layer.cornerRadius = avatarView.frame.size.width / 2;
    avatarView.clipsToBounds = YES;
    
    questionLabel.textColor = [wjAppearanceManager questionTitleLabelTextColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadAvatarImageWithApartURL:(NSString *)urlStr {
    [self.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], urlStr]] placeholderImage:[UIImage imageNamed:@"placeholderAvatar.png"]];
}

- (void)loadTopicImageWithApartURL:(NSString *)urlStr {
    [self.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs topicImagePath], urlStr]] placeholderImage:[UIImage imageNamed:@"placeholderTopic.png"]];
}

@end
