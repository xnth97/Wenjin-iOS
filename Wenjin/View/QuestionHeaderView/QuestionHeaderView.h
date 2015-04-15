//
//  QuestionHeaderView.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionHeaderViewDelegate <NSObject>

- (void)presentPostAnswerController;
- (void)headerDetailViewFinishLoadingWithView:(id)view;

@end

@interface QuestionHeaderView : UIView<UIWebViewDelegate>

@property (assign, nonatomic) id<QuestionHeaderViewDelegate> delegate;

- (id)initWithQuestionInfo:(NSDictionary *)questionInfo andTopics:(NSArray *)topics;

@end
