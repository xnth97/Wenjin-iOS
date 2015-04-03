//
//  UserHeaderView.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "UserHeaderView.h"

@implementation UserHeaderView {
    NSDictionary *userData;
}

@synthesize userAvatarView;
@synthesize usernameLabel;
@synthesize userSigLabel;
@synthesize agreeCountLabel;
@synthesize thanksCountLabel;
@synthesize followButton;

- (id)init {
    if (self = [super init]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:self options:nil] objectAtIndex:0];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
