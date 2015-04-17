//
//  PostViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "PostViewController.h"
#import "wjStringProcessor.h"
#import "PostDataManager.h"
#import "data.h"
#import "MsgDisplay.h"
#import "ALActionBlocks.h"
#import "TLTagsControl.h"
#import "HomeViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "wjAppearanceManager.h"

@interface PostViewController ()

@end

@implementation PostViewController {
    NSMutableArray *topicsArr;
    CGFloat tagsControlHeight;
    
    TLTagsControl *questionTagsControl;
}

@synthesize questionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Instaces init.
    [data shareInstance].postQuestionDetail = @"";
    topicsArr = [[NSMutableArray alloc]init];
    tagsControlHeight = 24.0;
    
    [data shareInstance].attachAccessKey = [self MD5FromNowDate];
    
    questionView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    questionView.font = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:questionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    UIToolbar *accessoryToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    accessoryToolbar.barStyle = UIBarStyleDefault;
    accessoryToolbar.translucent = YES;
    
    UIBarButtonItem *addDetailBtn = [[UIBarButtonItem alloc]initWithTitle:@"添加描述" style:UIBarButtonItemStylePlain block:^(id weakSender) {
        UIStoryboard *storyboard = self.storyboard;
        UINavigationController *addDetailNav = [storyboard instantiateViewControllerWithIdentifier:@"detailNav"];
        [self presentViewController:addDetailNav animated:YES completion:nil];
    }];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [accessoryToolbar setItems:@[flexibleSpace, flexibleSpace, addDetailBtn]];
    questionView.inputAccessoryView = accessoryToolbar;
    
    questionTagsControl = [[TLTagsControl alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    questionTagsControl.tags = topicsArr;
    questionTagsControl.mode = TLTagsControlModeEdit;
    questionTagsControl.tagsBackgroundColor = [wjAppearanceManager tagsControlBackgroundColor];
    questionTagsControl.tagsTextColor = [UIColor whiteColor];
    questionTagsControl.tagPlaceholder = @"添加话题";
    questionTagsControl.tagsDeleteButtonColor = [UIColor whiteColor];
    [questionTagsControl reloadTagSubviews];
    [self.view addSubview:questionTagsControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [questionView becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [questionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight - tagsControlHeight - 4)];
        [questionTagsControl setFrame:CGRectMake(8, questionView.frame.size.height, self.view.frame.size.width - 16, tagsControlHeight)];
    }];
    
}

- (void)dealloc {
    //使用通知中心后必须重写dealloc方法,进行释放(ARC)(非ARC还需要写上[super dealloc];)
    //removeObserver和 addObserver相对应.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)postQuestion {
    
    topicsArr = questionTagsControl.tags;
    
    NSString *topicsStr = @"";
    if ([topicsArr count] > 0) {
        for (int i = 0; i < [topicsArr count]; i ++) {
            if (i == 0) {
                topicsStr = (topicsArr)[0];
            } else {
                NSString *topic = (topicsArr)[i];
                topicsStr = [NSString stringWithFormat:@"%@,%@", topicsStr, topic];
            }
        }
    }
    
    // 成功提交后需清除单例模式里的数据
    
    if ([self.questionView.text isEqualToString:@""]) {
        [MsgDisplay showErrorMsg:@"NULL"];
    } else {
        NSDictionary *parameters = @{@"question_content": self.questionView.text,
                                     @"question_detail": [data shareInstance].postQuestionDetail,
                                     @"topics": topicsStr,
                                     @"attach_access_key": [data shareInstance].attachAccessKey};
        [PostDataManager postQuestionWithParameters:parameters success:^(NSString *questionId) {
            [MsgDisplay showSuccessMsg:[NSString stringWithFormat:@"问题发布成功！"]];
            
            for (UIViewController *navVc in self.navigationController.tabBarController.viewControllers) {
                if ([navVc isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *nVC = (UINavigationController *)navVc;
                    if ([nVC.viewControllers[0] isKindOfClass:[HomeViewController class]]) {
                        HomeViewController *hVC = (HomeViewController *)nVC.viewControllers[0];
                        hVC.shouldRefresh = YES;
                    }
                }
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [data shareInstance].postQuestionDetail = @"";
            [data shareInstance].attachAccessKey = @"";
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
    }
}

- (NSString *)MD5FromNowDate {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:utcTimeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowString = [formatter stringFromDate:now];
    NSString *inputString = [NSString stringWithFormat:@"%@ %@", nowString, [data shareInstance].myUID];
    
    const char *pointer = [inputString UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
    
    NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [string appendFormat:@"%02x",md5Buffer[i]];
    }
    
    return string;
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
