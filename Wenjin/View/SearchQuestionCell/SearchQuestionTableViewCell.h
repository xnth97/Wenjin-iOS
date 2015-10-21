//
//  SearchQuestionTableViewCell.h
//  Wenjin
//
//  Created by Qin Yubo on 15/10/20.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchQuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCountLabel;

@end
