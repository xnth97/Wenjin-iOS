//
//  WebModalViewController.m
//  
//
//  Created by Qin Yubo on 15/8/13.
//
//

#import "WebModalViewController.h"
#import "wjAppearanceManager.h"

@interface WebModalViewController ()

@end

@implementation WebModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setBarStyle:UIBarStyleDefault];
    self.navigationController.toolbar.tintColor = [wjAppearanceManager mainTintColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
