//
//  NotLoggedInView.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotLoggedInViewDelegate <NSObject>

- (void)presentLoginController;

@end

@interface NotLoggedInView : UIView<UIScrollViewDelegate, UIScrollViewAccessibilityDelegate>

@property (assign, nonatomic) id<NotLoggedInViewDelegate> delegate;

@end
