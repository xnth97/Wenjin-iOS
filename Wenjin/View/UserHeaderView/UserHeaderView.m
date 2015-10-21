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
#import "BlocksKit+UIKit.h"
#import "wjAppearanceManager.h"

@implementation UserHeaderView

@synthesize userAvatarView;
@synthesize usernameLabel;
@synthesize userSigLabel;
@synthesize agreeCountLabel;
@synthesize thanksCountLabel;
@synthesize followButton;
@synthesize delegate;
@synthesize userAgreeView;
@synthesize userThanksView;

- (id)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:self options:nil] objectAtIndex:0];
        [followButton bk_addEventHandler:^(id sender) {
            [delegate followUser];
        } forControlEvents:UIControlEventTouchUpInside];
        
        userAgreeView.image = [userAgreeView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [userAgreeView setTintColor:[UIColor lightGrayColor]];
        userThanksView.image = [userThanksView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [userThanksView setTintColor:[UIColor lightGrayColor]];
        
        [self addSubview:({
            UIView *splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 0.5)];
            [splitLine setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
            splitLine;
        })];
        
        [self addSubview:({
            UIView *splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, 1024, 0.5)];
            [splitLine setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
            splitLine;
        })];
        
    }
    return self;
}

- (void)loadAvatarImageWithApartURLString:(NSString *)urlStr {
    [userAvatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], urlStr]] placeholderImage:[UIImage imageNamed:@"placeholderAvatar.png"]];
    userAvatarView.layer.cornerRadius = userAvatarView.frame.size.width / 2;
    userAvatarView.clipsToBounds = YES;
}

- (void)reloadAvatarImageWithApartURLString:(NSString *)urlStr {
    // Do not cache in case user changed his avatar.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], urlStr]]];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [userAvatarView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholderAvatar.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            userAvatarView.image = image;
        });
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
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
