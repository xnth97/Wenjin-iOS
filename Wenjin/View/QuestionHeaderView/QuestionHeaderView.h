//
//  QuestionHeaderView.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"
#import "QuestionInfo.h"
#import "TopicInfo.h"

@protocol QuestionHeaderViewDelegate <NSObject>

- (void)presentPostAnswerController;

/**
 *  标签点击事件
 *
 *  @param index 被点击的标签序号
 */
- (void)tagTappedAtIndex:(NSInteger)index;

/**
 *  WebView 改变大小时回调 headerView
 *
 *  @param view 回调的 QuestionHeaderView
 */
- (void)headerDetailViewFinishLoadingWithView:(id)view;

- (void)URLClicked:(NSURL *)url;

@end

@interface QuestionHeaderView : UIView<UIWebViewDelegate, TLTagsControlDelegate>

@property (assign, nonatomic) id<QuestionHeaderViewDelegate> delegate;
@property (strong, nonatomic) UIWebView *detailView;

- (id)initWithQuestionInfo:(QuestionInfo *)questionInfo andTopics:(NSArray *)topics;

@end
