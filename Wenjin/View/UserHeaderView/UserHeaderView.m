//
//  UserHeaderView.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "UserHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "wjAPIs.h"
#import "ALActionBlocks.h"

@implementation UserHeaderView

@synthesize userAvatarView;
@synthesize usernameLabel;
@synthesize userSigLabel;
@synthesize agreeCountLabel;
@synthesize thanksCountLabel;
@synthesize followButton;
@synthesize delegate;

- (id)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:self options:nil] objectAtIndex:0];
        [followButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
            [delegate followUser];
        }];
    }
    return self;
}

- (void)loadAvatarImageWithApartURLString:(NSString *)urlStr {
    [userAvatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], urlStr]]];
    userAvatarView.layer.cornerRadius = userAvatarView.frame.size.width / 2;
    userAvatarView.clipsToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
