//
//  QuestionHeaderView.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "QuestionHeaderView.h"
#import "wjStringProcessor.h"
#import "ALActionBlocks.h"

@implementation QuestionHeaderView {
    int _borderDist;
}

- (id)init {
    if (self = [super init]) {
        // self = [[[NSBundle mainBundle] loadNibNamed:@"QuestionHeaderView" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (id)initWithQuestionInfo:(NSDictionary *)questionInfo andTopics:(NSArray *)topics {
    if (self = [self init]) {
        
        _borderDist = 14 ;
        CGFloat width = [UIApplication sharedApplication].keyWindow.frame.size.width;
        
        UIScrollView *topicView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width - 22, 22)];
        topicView.showsHorizontalScrollIndicator = NO;
        topicView.contentSize = CGSizeMake(600, 22);
        [self addSubview:topicView];
        
        UILabel *questionTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        questionTitle.numberOfLines = 0;
        questionTitle.lineBreakMode = NSLineBreakByWordWrapping;
        questionTitle.text = [wjStringProcessor filterHTMLWithString:questionInfo[@"question_content"]];
        questionTitle.font = [UIFont systemFontOfSize:20];
        CGSize maxSize = CGSizeMake(width - _borderDist * 2, 1000);
        CGSize questionFitSize = [questionTitle sizeThatFits:maxSize];
        questionTitle.frame = CGRectMake(_borderDist + 4, 42, width - 2 * _borderDist, questionFitSize.height);
        [self addSubview:questionTitle];

        UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        detailTextView.editable = NO;
        detailTextView.scrollEnabled = NO;
        detailTextView.font = [UIFont systemFontOfSize:14];
        detailTextView.text = [wjStringProcessor filterHTMLWithString:questionInfo[@"question_detail"]];
        CGSize detailFitSize = [detailTextView sizeThatFits:maxSize];
        detailTextView.frame = CGRectMake(_borderDist, 42 + questionFitSize.height + 20, width - 2 * _borderDist, detailFitSize.height);
        [self addSubview:detailTextView];
        
        UIButton *focusQuestion = [UIButton buttonWithType:UIButtonTypeSystem];
        [focusQuestion setTitle:(([questionInfo[@"has_focus"] isEqual:@1]) ? @"取消关注" : @"关注问题") forState:UIControlStateNormal];
        focusQuestion.frame = CGRectMake(0, 42 + questionFitSize.height + 20 + detailFitSize.height + 20, 0.5 * width, 30);
        [focusQuestion handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
            NSLog(@"Focus Action");
            if (([questionInfo[@"has_focus"] isEqual:@1])) {
                // 取消关注
            } else {
                // 关注问题
            }
        }];
        [self addSubview:focusQuestion];
        
        UIButton *addAnswer = [UIButton buttonWithType:UIButtonTypeSystem];
        [addAnswer setTitle:@"添加回答" forState:UIControlStateNormal];
        addAnswer.frame = CGRectMake(0.5 * width, 42 + questionFitSize.height + 20 + detailFitSize.height + 20, 0.5 * width, 30);
        [addAnswer handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
            NSLog(@"Add answer action");
            // 添加回答
        }];
        [self addSubview:addAnswer];
        
        self.frame = CGRectMake(0, 0, width, 42 + questionFitSize.height + 20 + detailFitSize.height + 50);
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}


@end
