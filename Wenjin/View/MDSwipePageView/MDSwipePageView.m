//
//  MDSwipePageView.m
//  MDSPCExample
//
//  Created by 秦昱博 on 15/6/12.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "MDSwipePageView.h"

#define selectorHeight 4

@implementation MDSwipePageView {
    UIScrollView *mainScrollView;
    UIView *titleView;
    UIView *selectorView;
    
    NSUInteger currentPage;
    NSUInteger lastSelectedPage;
    
    NSMutableArray *titleLabels;
}

@synthesize mainColor;
@synthesize titlesForSubPageViews;
@synthesize subPageViews;
@synthesize delegate;
@synthesize selectedTitleColor;
@synthesize unselectedTitleColor;
@synthesize selectorColor;
@synthesize titleHeight;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self initializeInstances];
    
    titleLabels = [[NSMutableArray alloc] init];
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleHeight, self.frame.size.width, self.frame.size.height - titleHeight)];
    mainScrollView.contentSize = CGSizeMake(subPageViews.count * mainScrollView.frame.size.width, mainScrollView.frame.size.height);
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.backgroundColor = [UIColor whiteColor];
    mainScrollView.delegate = self;
    [self addSubview:mainScrollView];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, titleHeight)];
    titleView.backgroundColor = mainColor;
    titleView.layer.shadowOffset = CGSizeMake(0, 2.0);
    titleView.layer.shadowOpacity = 0.3;
    titleView.layer.shadowRadius = 3.0;
    [self addSubview:titleView];
    
    for (int i = 0; i < subPageViews.count; i ++) {
        
        [mainScrollView addSubview:({
            UIView *tmpView = subPageViews[i];
            [tmpView setFrame:CGRectMake(i * mainScrollView.frame.size.width, 0, mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
            tmpView;
        })];
        
        [titleView addSubview:({
            UILabel *tmpLabel = [[UILabel alloc] init];
            [tmpLabel setFrame:CGRectMake(i * titleView.frame.size.width / subPageViews.count, 0, titleView.frame.size.width / subPageViews.count, titleView.frame.size.height)];
            tmpLabel.text = [titlesForSubPageViews[i] description];
            tmpLabel.textColor = unselectedTitleColor;
            tmpLabel.font = [UIFont systemFontOfSize:14];
            tmpLabel.textAlignment = NSTextAlignmentCenter;
            tmpLabel.tag = i;
            tmpLabel.userInteractionEnabled = YES;
            [tmpLabel addGestureRecognizer:({
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizerTapped:)];
                tapRecognizer.numberOfTapsRequired = 1;
                tapRecognizer.delegate = self;
                tapRecognizer;
            })];
            [titleLabels addObject:tmpLabel];
            tmpLabel;
        })];
    }
    
    selectorView = [[UIView alloc] initWithFrame:CGRectMake(0, titleHeight - selectorHeight, titleView.frame.size.width / subPageViews.count, selectorHeight)];
    selectorView.backgroundColor = selectorColor;
    [titleView addSubview:selectorView];
    
//    NSDictionary *views = NSDictionaryOfVariableBindings(titleView, mainScrollView);
//    NSDictionary *metrics = @{@"titleHeight": [NSNumber numberWithFloat:titleHeight]};
//    NSString *vfl1 = @"V:|-[titleView(titleHeight)]-[mainScrollView]-|";
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:views]];
    
    [delegate swipePageView:self pageChangedToIndex:0];
    currentPage = 0;
    ((UILabel *)titleLabels[0]).textColor = selectedTitleColor;
}

- (void)recognizerTapped:(UITapGestureRecognizer *)sender {
    //NSLog(@"%ld tapped.", (long)sender.view.tag);
    lastSelectedPage = currentPage;
    [mainScrollView setContentOffset:CGPointMake(sender.view.tag * mainScrollView.frame.size.width, 0) animated:YES];
    currentPage = sender.view.tag;
    if (currentPage != lastSelectedPage) {
        [delegate swipePageView:self pageChangedToIndex:currentPage];
    }
    [self changeLabelColors];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    float offSetX = offset.x;
    
    if (offSetX >= 0 && offSetX <= (subPageViews.count - 1) * mainScrollView.frame.size.width) {
        //NSLog(@"OffSetX = %f", offSetX);
        [selectorView setCenter:CGPointMake(offSetX / subPageViews.count + selectorView.frame.size.width / 2, selectorView.center.y)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    float offSetX = offset.x;
    NSUInteger index = offSetX / mainScrollView.frame.size.width;
    lastSelectedPage = currentPage;
    currentPage = index;
    if (currentPage != lastSelectedPage) {
        [delegate swipePageView:self pageChangedToIndex:currentPage];
    }
    
    [self changeLabelColors];
}

- (NSUInteger)currentPage {
    return currentPage;
}

- (void)initializeInstances {
    if (titleHeight == 0) {
        titleHeight = 64;
    }
    
    if (selectedTitleColor == nil) {
        selectedTitleColor = [UIColor whiteColor];
    }
    
    if (unselectedTitleColor == nil) {
        unselectedTitleColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    }
    
    if (selectorColor == nil) {
        selectorColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
}

- (void)changeLabelColors {
    ((UILabel *)titleLabels[lastSelectedPage]).textColor = unselectedTitleColor;
    ((UILabel *)titleLabels[currentPage]).textColor = selectedTitleColor;
}

@end
