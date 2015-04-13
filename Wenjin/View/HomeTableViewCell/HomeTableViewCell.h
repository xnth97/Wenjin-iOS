//
//  HomeTableViewCell.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol homeTableViewCellDelegate <NSObject>

- (void)pushUserControllerWithRow:(NSUInteger)row;
- (void)pushQuestionControllerWithRow:(NSUInteger)row;
- (void)pushAnswerControllerWithRow:(NSUInteger)row;

@end

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (assign, nonatomic) id<homeTableViewCellDelegate> delegate;

- (void)loadAvatarImageWithApartURL:(NSString *)urlStr;

@end
