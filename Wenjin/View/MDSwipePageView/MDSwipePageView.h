//
//  MDSwipePageView.h
//  MDSPCExample
//
//  Created by 秦昱博 on 15/6/12.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDSwipePageView;

@protocol MDSwipePageViewDelegate <NSObject>

- (void)swipePageView:(MDSwipePageView *)pageView pageChangedToIndex:(NSUInteger)index;

@end

@interface MDSwipePageView : UIView<UIScrollViewAccessibilityDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *titlesForSubPageViews;
@property (strong, nonatomic) NSArray *subPageViews;
@property (strong, nonatomic) UIColor *mainColor;

@property (strong, nonatomic) UIColor *selectedTitleColor;
@property (strong, nonatomic) UIColor *unselectedTitleColor;
@property (strong, nonatomic) UIColor *selectorColor;
@property (nonatomic) float titleHeight;

@property (assign, nonatomic) id<MDSwipePageViewDelegate> delegate;

- (NSUInteger)currentPage;

@end
