//
//  MainTabBarController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/28.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotLoggedInView.h"
#import "wjAppearanceManager.h"

@interface MainTabBarController : UITabBarController <NotLoggedInViewDelegate>

@property (nonatomic) BOOL showNotLoggedInView;

@end
