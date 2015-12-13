//
//  UserHeaderView.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserHeaderViewDelegate <NSObject>

- (void)followUser;

@end

@interface UserHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSigLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *thanksCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarView;
@property (weak, nonatomic) IBOutlet UIImageView *userAgreeView;
@property (weak, nonatomic) IBOutlet UIImageView *userThanksView;
@property (weak, nonatomic) IBOutlet UIImageView *curveView;

@property (assign, nonatomic) id<UserHeaderViewDelegate> delegate;

- (void)loadAvatarImageWithApartURLString:(NSString *)urlStr;
- (void)reloadAvatarImageWithApartURLString:(NSString *)urlStr;

@end
