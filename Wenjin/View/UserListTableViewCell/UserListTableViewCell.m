//
//  UserListTableViewCell.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "UserListTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "wjAPIs.h"

@implementation UserListTableViewCell

@synthesize avatarView;
@synthesize userNameLabel;
@synthesize userSigLabel;

- (void)awakeFromNib {
    // Initialization code
    avatarView.layer.cornerRadius = avatarView.frame.size.width / 2;
    avatarView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadImageWithApartURL:(NSString *)urlStr {
    [self.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], urlStr]] placeholderImage:[UIImage imageNamed:@"placeholderAvatar.png"]];
}

- (void)loadTopicImageWithApartURL:(NSString *)urlStr {
    [self.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs topicImagePath], urlStr]] placeholderImage:[UIImage imageNamed:@"placeholderTopic.png"]];
}

- (void)loadImageWithURL:(NSString *)urlStr {
    [self.avatarView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholderTopic.png"]];
}
@end
