//
//  CommentTextView.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/27.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "CommentTextView.h"

@implementation CommentTextView

- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.placeholder = NSLocalizedString(@"请输入评论", nil);
    self.placeholderColor = [UIColor lightGrayColor];
    self.pastableMediaTypes = SLKPastableMediaTypeNone;
    
    self.layer.borderColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
