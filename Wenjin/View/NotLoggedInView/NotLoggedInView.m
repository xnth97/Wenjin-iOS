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

@implementation NotLoggedInView

@synthesize delegate;

- (id)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NotLoggedInView" owner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (IBAction)login {
    [delegate presentLoginController];
}

- (void)setNeedsDisplay {
    if ([wjAccountManager userIsLoggedIn]) {
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
