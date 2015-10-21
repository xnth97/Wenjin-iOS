//
//  UserListTableViewCell.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSigLabel;

- (void)loadImageWithApartURL:(NSString *)urlStr;
- (void)loadTopicImageWithApartURL:(NSString *)urlStr;
- (void)loadImageWithURL:(NSString *)urlStr;

@end
