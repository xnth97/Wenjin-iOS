//
//  WebViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/20.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "BlocksKit+UIKit.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"快速注册";
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.clipsToBounds = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wenjin.in/account/green/"]]];
    [self.view addSubview:webView];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    self.navigationItem.rightBarButtonItem = doneBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
