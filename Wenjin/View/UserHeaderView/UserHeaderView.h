//
//  UserHeaderView.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSigLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *thanksCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarView;

- (void)loadAvatarImageWithApartURLString:(NSString *)urlStr;

@end
