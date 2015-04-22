//
//  AboutViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/18.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "AboutViewController.h"
#import "wjAppearanceManager.h"
#import "data.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize versionLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于问津";
    versionLabel.text = [NSString stringWithFormat:@"问津 %@ Build %@", [data appVersion], [data appBuild]];
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
