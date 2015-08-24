//
//  HomeTableViewCell.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol homeTableViewCellDelegate <NSObject>

/**
 *  点击用户及头像响应事件
 *
 *  @param row 点击 cell 行数
 */
- (void)pushUserControllerWithRow:(NSUInteger)row;

/**
 *  点击标题响应事件
 *
 *  @param row 点击 cell 行数
 */
- (void)pushQuestionControllerWithRow:(NSUInteger)row;

/**
 *  点击内容响应事件
 *
 *  @param row 点击 cell 行数
 */
- (void)pushDetailControllerWithRow:(NSUInteger)row;

@end

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (assign, nonatomic) id<homeTableViewCellDelegate> delegate;

- (void)loadAvatarImageWithApartURL:(NSString *)urlStr;
- (void)loadTopicImageWithApartURL:(NSString *)urlStr;

@end
