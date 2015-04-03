//
//  QuestionAnswerTableViewCell.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionCellPushUserDelegate <NSObject>

- (void)pushUserControllerWithRow:(NSUInteger)row;

@end

@interface QuestionAnswerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarView;
@property (weak, nonatomic) IBOutlet UILabel *agreeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerContentLabel;

@property (assign, nonatomic) id<QuestionCellPushUserDelegate> delegate;

- (void)loadAvatarWithURL:(NSString *)urlStr;

@end
