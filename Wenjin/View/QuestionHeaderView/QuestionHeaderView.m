//
//  QuestionHeaderView.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "QuestionHeaderView.h"
#import "wjStringProcessor.h"
#import "BlocksKit+UIKit.h"
#import "wjOperationManager.h"
#import "MsgDisplay.h"
#import "wjAPIs.h"
#import "wjAppearanceManager.h"
#import "FBKVOController.h"
#import <SafariServices/SafariServices.h>

@implementation QuestionHeaderView {
    int _borderDist;
    
    TLTagsControl *topicsControl;
    UILabel *questionTitle;
    UIButton *focusQuestion;
    UIButton *addAnswer;
    CGFloat width;
    
    UIView *splitLine;
}

@synthesize delegate;
@synthesize detailView;

- (id)init {
    if (self = [super init]) {
        // self = [[[NSBundle mainBundle] loadNibNamed:@"QuestionHeaderView" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (id)initWithQuestionInfo:(QuestionInfo *)questionInfo andTopics:(NSArray *)topics {
    if (self = [self init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _borderDist = 12 ;
        width = [UIScreen mainScreen].bounds.size.width;
        
        NSMutableArray *topicsArr = [[NSMutableArray alloc]init];
        for (TopicInfo *tmp in topics) {
            [topicsArr addObject:tmp.topicTitle];
        }
        
        topicsControl = [[TLTagsControl alloc]initWithFrame:CGRectMake(16, 8, width - 32, 22)];
        // TLTagsControl *topicsControl = [[TLTagsControl alloc]init];
        topicsControl.mode = TLTagsControlModeList;
        topicsControl.tags = topicsArr;
        topicsControl.tagsBackgroundColor = [wjAppearanceManager tagsControlBackgroundColor];
        topicsControl.tagsTextColor = [UIColor whiteColor];
        topicsControl.tagsDeleteButtonColor = [UIColor whiteColor];
        [topicsControl reloadTagSubviews];
        topicsControl.tapDelegate = self;
        //topicsControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:topicsControl];
        
        questionTitle = [[UILabel alloc]init];
        questionTitle.numberOfLines = 0;
        questionTitle.lineBreakMode = NSLineBreakByWordWrapping;
        questionTitle.text = [wjStringProcessor filterHTMLWithString:questionInfo.questionContent];
        questionTitle.font = [UIFont systemFontOfSize:20];
        //questionTitle.translatesAutoresizingMaskIntoConstraints = NO;
        CGSize maxSize = CGSizeMake(width - _borderDist * 2, 1000);
        CGSize questionFitSize = [questionTitle sizeThatFits:maxSize];
        questionTitle.frame = CGRectMake(_borderDist + 4, 42, width - 2 * _borderDist, questionFitSize.height + 20);
        [self addSubview:questionTitle];
        
        detailView = [[UIWebView alloc]init];
        [detailView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
        detailView.frame = CGRectMake(0, 42 + questionTitle.frame.size.height, width, 1);
        if (![questionInfo.questionDetail isEqualToString:@""]) {
            [detailView loadHTMLString:[wjStringProcessor convertToBootstrapHTMLWithContent:questionInfo.questionDetail] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory:YES]];
            detailView.delegate = self;
        }
        detailView.hidden = NO;
        [self addSubview:detailView];
        
        focusQuestion = [UIButton buttonWithType:UIButtonTypeSystem];
        [focusQuestion setTitle:((questionInfo.hasFocus == 1) ? @"取消关注" : @"关注问题") forState:UIControlStateNormal];
        focusQuestion.frame = CGRectMake(0, 42 + questionTitle.frame.size.height + detailView.frame.size.height, 0.5 * width, 30);
        [focusQuestion bk_addEventHandler:^(id weakSender) {
            NSLog(@"Focus Action");
            [wjOperationManager followQuestionWithQuestionID:[NSString stringWithFormat:@"%ld", (long)questionInfo.questionId] success:^(NSString *operationType) {
                
                if ([operationType isEqualToString:@"remove"]) {
                    [focusQuestion setTitle:@"关注问题" forState:UIControlStateNormal];
                } else if ([operationType isEqualToString:@"add"]) {
                    [focusQuestion setTitle:@"取消关注" forState:UIControlStateNormal];
                }
                
            } failure:^(NSString *errStr) {
                [MsgDisplay showErrorMsg:errStr];
            }];
        } forControlEvents:UIControlEventTouchUpInside];
        //focusQuestion.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:focusQuestion];
        
        addAnswer = [UIButton buttonWithType:UIButtonTypeSystem];
        [addAnswer setTitle:@"添加回答" forState:UIControlStateNormal];
        addAnswer.frame = CGRectMake(0.5 * width, 42 + questionTitle.frame.size.height + detailView.frame.size.height, 0.5 * width, 30);
        [addAnswer bk_addEventHandler:^(id sender) {
            NSLog(@"Add answer action");
            // 添加回答
            [delegate presentPostAnswerController];
        } forControlEvents:UIControlEventTouchUpInside];
        //addAnswer.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:addAnswer];
        
        self.frame = CGRectMake(0, 0, width, 42 + questionTitle.frame.size.height + detailView.frame.size.height + 42);
        
        splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
        [splitLine setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
        [self addSubview:splitLine];
        
        //self.frame = CGRectMake(0, 0, width, 0);
        
//        NSDictionary *views = NSDictionaryOfVariableBindings(topicsControl, questionTitle, detailView, focusQuestion, addAnswer);
//        NSDictionary *metrics = @{@"borderDist": @16,
//                                  @"rowDist": @14};
//        NSString *vfl1 = @"|-borderDist-[topicsControl]-borderDist-|";
//        NSString *vfl2 = @"|-borderDist-[questionTitle]-borderDist-|";
//        NSString *vfl3 = @"|-borderDist-[detailView]-borderDist-|";
//        NSString *vfl4 = @"|-0-[focusQuestion]-0-[addAnswer(focusQuestion)]-0-|";
//        NSString *vfl5 = ([questionInfo.questionDetail isEqualToString:@""]) ? @"V:|-8-[topicsControl(22)]-rowDist-[questionTitle]-rowDist-[detailView(0)]-50-|" : @"V:|-8-[topicsControl(22)]-rowDist-[questionTitle]-rowDist-[detailView]-50-|";
//        NSString *vfl6 = @"V:[focusQuestion(30)]-12-|";
//        NSString *vfl7 = @"V:[addAnswer(30)]-12-|";
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:metrics views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3 options:0 metrics:metrics views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4 options:0 metrics:metrics views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5 options:0 metrics:metrics views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl6 options:0 metrics:metrics views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl7 options:0 metrics:metrics views:views]];
//        
//        CGFloat headerHeight = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        CGRect headerFrame = self.frame;
//        headerFrame.size.height = headerHeight;
//        
//        self.frame = headerFrame;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == detailView.scrollView && [keyPath isEqualToString:@"contentSize"]) {
        UIScrollView *scroll = detailView.scrollView;
        scroll.scrollEnabled = NO;
        CGRect detailFrame = detailView.frame;
        NSLog(@"%f", detailFrame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            detailView.frame = CGRectMake(detailFrame.origin.x, detailFrame.origin.y, scroll.contentSize.width, scroll.contentSize.height);
            detailView.hidden = NO;
            focusQuestion.frame = CGRectMake(0, 42 + questionTitle.frame.size.height + detailView.frame.size.height, 0.5 * width, 30);
            addAnswer.frame = CGRectMake(0.5 * width, 42 + questionTitle.frame.size.height + detailView.frame.size.height, 0.5 * width, 30);
            self.frame = CGRectMake(0, 0, width, 42 + questionTitle.frame.size.height + detailView.frame.size.height + 42);
            
            splitLine.frame = CGRectMake(0, self.frame.size.height - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5);
        }];
        
        [delegate headerDetailViewFinishLoadingWithView:self];
    }
}

- (void)dealloc {
    [detailView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

/*
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    UIScrollView *scroll = webView.scrollView;
    scroll.scrollEnabled = NO;
    CGRect detailFrame = webView.frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        webView.frame = CGRectMake(detailFrame.origin.x, detailFrame.origin.y, scroll.contentSize.width, scroll.contentSize.height);
        detailView.hidden = NO;
        focusQuestion.frame = CGRectMake(0, 42 + questionTitle.frame.size.height + detailView.frame.size.height, 0.5 * width, 30);
        addAnswer.frame = CGRectMake(0.5 * width, 42 + questionTitle.frame.size.height + detailView.frame.size.height, 0.5 * width, 30);
        self.frame = CGRectMake(0, 0, width, 42 + questionTitle.frame.size.height + detailView.frame.size.height + 42);
        
        splitLine.frame = CGRectMake(0, self.frame.size.height - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5);
    }];
    
    [delegate headerDetailViewFinishLoadingWithView:self];
}
 */

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [delegate URLClicked:[request URL]];
        return NO;
    } else {
        return YES;
    }
}

- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    [delegate tagTappedAtIndex:index];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}

- (UIViewController *)appRootViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
