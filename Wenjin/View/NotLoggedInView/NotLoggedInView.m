//
//  NotLoggedInView.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "NotLoggedInView.h"
#import "LoginViewController.h"
#import "wjAccountManager.h"
#import <POP/POP.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import "wjAppearanceManager.h"

@implementation NotLoggedInView {
    UIScrollView *backgroundScrollView;
    UIScrollView *foregroundScrollView;
    UIButton *loginBtn;
    UIPageControl *pageControl;
    
    CGFloat deviceWidth;
    CGFloat deviceHeight;
    
    CGFloat btnOriginHeightBefore;
    CGFloat btnOriginHeightAfter;
    CGFloat btnWidth;
    CGFloat btnHeight;
}

@synthesize delegate;

- (id)init {
    if (self = [super init]) {
        //self = [[[NSBundle mainBundle] loadNibNamed:@"NotLoggedInView" owner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [UIColor whiteColor];
        
        deviceHeight = [UIScreen mainScreen].bounds.size.height;
        deviceWidth = [UIScreen mainScreen].bounds.size.width;
        
        btnWidth = 200;
        btnHeight = 46;
        btnOriginHeightAfter = deviceHeight - 180;
        btnOriginHeightBefore = deviceHeight - 80;
        
        backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
        [backgroundScrollView setBackgroundColor:[UIColor grayColor]];
        [backgroundScrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:backgroundScrollView];
        
        UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guideBackground"]];
        backgroundView.frame = CGRectMake(0, 0, 1.5 * deviceHeight, deviceHeight);
        [backgroundScrollView addSubview:backgroundView];
        
        foregroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
        [self addSubview:foregroundScrollView];
        [foregroundScrollView setContentSize:CGSizeMake(3 * deviceWidth, deviceHeight)];
        [foregroundScrollView setBackgroundColor:[UIColor clearColor]];
        [foregroundScrollView setPagingEnabled:YES];
        [foregroundScrollView setShowsHorizontalScrollIndicator:NO];
        [foregroundScrollView setDelegate:self];
        
        UIImageView *imgView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide1"]];
        imgView1.frame = CGRectMake(0, 0, deviceWidth, deviceHeight);
        [foregroundScrollView addSubview:imgView1];
        
        UIImageView *imgView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide2"]];
        imgView2.frame = CGRectMake(deviceWidth, 0, deviceWidth, deviceHeight);
        [foregroundScrollView addSubview:imgView2];
        
        UIImageView *imgView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide3"]];
        imgView3.frame = CGRectMake(2*deviceWidth, 0, deviceWidth, deviceHeight);
        [foregroundScrollView addSubview:imgView3];
        
        loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setTitle:@"进入问津" forState:UIControlStateNormal];
        [loginBtn setFrame:CGRectMake(0.5 * deviceWidth - 0.5 * btnWidth, btnOriginHeightBefore, btnWidth, btnHeight)];
        [loginBtn setTintColor:[UIColor whiteColor]];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn.layer setCornerRadius:7.0];
        [loginBtn setClipsToBounds:YES];
        [loginBtn bk_addEventHandler:^(id sender) {
            [delegate presentLoginController];
        } forControlEvents:UIControlEventTouchUpInside];
        [loginBtn setBackgroundColor:[UIColor clearColor]];
        [loginBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [loginBtn.layer setBorderWidth:1.0];
        [loginBtn setAlpha:0.0];
        [loginBtn setUserInteractionEnabled:NO];
        [self addSubview:loginBtn];
        
        pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width/2, deviceHeight - 20, 0, 0)];
        [pageControl setNumberOfPages:3];
        [pageControl setUserInteractionEnabled:NO];
        [self addSubview:pageControl];
        
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == foregroundScrollView) {
        CGPoint offset = scrollView.contentOffset;
        [UIView animateWithDuration:0.3 animations:^{
            pageControl.currentPage = offset.x / deviceWidth;
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == foregroundScrollView) {
        float offSetX = scrollView.contentOffset.x;
        if (offSetX >= 0 && offSetX <= 2 * deviceWidth) {
            //NSLog(@"%f", offSetX);
            [backgroundScrollView setContentOffset:CGPointMake(0.5 * offSetX / 2, 0)];
            
            if (offSetX >= 1.5 * deviceWidth && offSetX <= 2.0 * deviceWidth) {
                [loginBtn setUserInteractionEnabled:YES];
                [loginBtn setAlpha:offSetX * 2 / deviceWidth - 3.0];
                [loginBtn setFrame:CGRectMake(0.5 * deviceWidth - 0.5 * btnWidth, (btnOriginHeightAfter - btnOriginHeightBefore) * offSetX / (0.5 * deviceWidth) + 4 * btnOriginHeightBefore - 3 * btnOriginHeightAfter, btnWidth, btnHeight)];
            } else {
                [loginBtn setUserInteractionEnabled:NO];
                [loginBtn setAlpha:0.0];
            }
        }
    }
}

@end
