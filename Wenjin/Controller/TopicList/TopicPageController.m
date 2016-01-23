//
//  TopicPageController.m
//  Wenjin
//
//  Created by Qin Yubo on 15/12/13.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import "TopicPageController.h"
#import "TopicListTableViewController.h"
#import "SearchViewController.h"
#import "wjAppearanceManager.h"

@interface TopicPageController ()

@end

@implementation TopicPageController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self) {
        self.viewControllerClasses = @[[TopicListTableViewController class], [TopicListTableViewController class]];
        self.titles = @[@"热门", @"我关注的"];
        self.keys = [@[@"topicType", @"topicType"] mutableCopy];
        self.values = [@[@"hot", @"focus"] mutableCopy];
        
        // customization
        self.pageAnimatable = YES;
        self.titleSizeSelected = 15.0;
        self.titleSizeNormal = 15.0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleColorSelected = [wjAppearanceManager mainTintColor];
        self.titleColorNormal = [UIColor darkGrayColor];
        //        self.menuItemWidth = 100;
        self.bounces = YES;
        self.menuHeight = [wjAppearanceManager pageMenuHeight];
        self.menuViewBottom = -(self.menuHeight + 64.0);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Appearance Customization
    self.menuView.layer.shadowColor = [wjAppearanceManager pageShadowColor].CGColor;
    self.menuView.layer.shadowOffset = [wjAppearanceManager pageShadowOffset];
    self.menuView.layer.shadowOpacity = [wjAppearanceManager pageShadowOpacity];
    self.menuView.layer.shadowRadius = [wjAppearanceManager pageShadowRadius];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"presentSearch"]) {
        SearchViewController *des = (SearchViewController *)segue.destinationViewController;
        des.searchType = 1;
    }
    segue.destinationViewController.hidesBottomBarWhenPushed = YES;
}

@end
