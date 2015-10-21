//
//  PostViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "PostQuestionViewController.h"
#import "wjStringProcessor.h"
#import "PostDataManager.h"
#import "data.h"
#import "MsgDisplay.h"
#import "BlocksKit+UIKit.h"
#import "TLTagsControl.h"
#import "HomeViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "wjAppearanceManager.h"
#import "NYSegmentedControl.h"
#import "wjDatabaseManager.h"

@interface PostQuestionViewController ()

@end

@implementation PostQuestionViewController {
    NSMutableArray *topicsArr;
    CGFloat tagsControlHeight;
    
    TLTagsControl *questionTagsControl;
    NYSegmentedControl *isAnonymousControl;
}

@synthesize questionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:[wjAppearanceManager mainTintColor]];
    
    // Instaces init.
    [data shareInstance].postQuestionDetail = [[NSMutableAttributedString alloc] initWithString:@""];
    topicsArr = [[NSMutableArray alloc]init];
    tagsControlHeight = 24.0;
    [data shareInstance].attachAccessKey = [self MD5FromNowDate];
    
    questionView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    questionView.font = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:questionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIToolbar *accessoryToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    accessoryToolbar.barStyle = UIBarStyleDefault;
    accessoryToolbar.translucent = YES;
    
    isAnonymousControl = [[NYSegmentedControl alloc]initWithItems:@[@"不匿名", @"匿名"]];
    isAnonymousControl.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    isAnonymousControl.segmentIndicatorBackgroundColor = [UIColor whiteColor];
    isAnonymousControl.segmentIndicatorInset = 0.0f;
    isAnonymousControl.titleTextColor = [UIColor lightGrayColor];
    isAnonymousControl.selectedTitleTextColor = [wjAppearanceManager mainTintColor];
    [isAnonymousControl sizeToFit];
    
    if (self.draftToBeLoaded != nil) {
        [self loadFromQuestionDraft:self.draftToBeLoaded];
    }
    
    UIBarButtonItem *isAnonymousBtn = [[UIBarButtonItem alloc]initWithCustomView:isAnonymousControl];
    UIBarButtonItem *addDetailBtn = [[UIBarButtonItem alloc] bk_initWithTitle:@"添加描述" style:UIBarButtonItemStylePlain handler:^(id weakSender) {
        UIStoryboard *storyboard = self.storyboard;
        UINavigationController *addDetailNav = [storyboard instantiateViewControllerWithIdentifier:@"detailNav"];
//        addDetailNav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:addDetailNav animated:YES completion:nil];
    }];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [accessoryToolbar setItems:@[isAnonymousBtn, flexibleSpace, addDetailBtn]];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attachUploadFinished:) name:@"attachIDCompleted" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [questionView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        [questionTagsControl reloadTagSubviews];
    }];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [questionView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight - tagsControlHeight - 4 - 64)];
        [questionTagsControl setFrame:CGRectMake(8, questionView.frame.size.height + 64, self.view.frame.size.width - 16, tagsControlHeight)];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        [questionView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 44 - tagsControlHeight - 4 - 64)];
        [questionTagsControl setFrame:CGRectMake(8, questionView.frame.size.height + 64, self.view.frame.size.width - 16, tagsControlHeight)];
    }];
}

- (void)dealloc {
    //使用通知中心后必须重写dealloc方法,进行释放(ARC)(非ARC还需要写上[super dealloc];)
    //removeObserver和 addObserver相对应.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadFromQuestionDraft:(QuestionDraft *)draft {
    // set data
    [data shareInstance].postQuestionDetail = [NSKeyedUnarchiver unarchiveObjectWithData:draft.questionDetail];
    [data shareInstance].attachAccessKey = draft.attachAccessKey;
    topicsArr = [[NSKeyedUnarchiver unarchiveObjectWithData:draft.topicArrData] mutableCopy];
    
    // set view
    self.questionView.text = draft.questionTitle;
    isAnonymousControl.selectedSegmentIndex = draft.anonymous;
}

- (IBAction)postQuestion {
    [MsgDisplay showLoading];
    
    // 成功提交后需清除单例模式里的数据
    
    if (self.questionView.attributedText.length == 0) {
        [MsgDisplay showErrorMsg:@"请填写问题内容喔"];
    } else {
        [PostDataManager uploadAttachFromAttributedString:[data shareInstance].postQuestionDetail withAttachType:@"question"];
//        NSDictionary *parameters = @{@"question_content": self.questionView.text,
//                                     @"question_detail": plainString,
//                                     @"topics": topicsStr,
//                                     @"attach_access_key": [data shareInstance].attachAccessKey,
//                                     @"anonymous": [NSNumber numberWithInteger:isAnonymousControl.selectedSegmentIndex]};
//        [PostDataManager postQuestionWithParameters:parameters success:^(NSString *questionId) {
//            [MsgDisplay dismiss];
//            [MsgDisplay showSuccessMsg:[NSString stringWithFormat:@"问题发布成功！"]];
//            
//            for (UIViewController *navVc in self.navigationController.tabBarController.viewControllers) {
//                if ([navVc isKindOfClass:[UINavigationController class]]) {
//                    UINavigationController *nVC = (UINavigationController *)navVc;
//                    if ([nVC.viewControllers[0] isKindOfClass:[HomeViewController class]]) {
//                        HomeViewController *hVC = (HomeViewController *)nVC.viewControllers[0];
//                        hVC.shouldRefresh = YES;
//                    }
//                }
//            }
//            
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            [data shareInstance].postQuestionDetail = nil;
//            [data shareInstance].attachAccessKey = @"";
//        } failure:^(NSString *errStr) {
//            [MsgDisplay dismiss];
//            [MsgDisplay showErrorMsg:errStr];
//        }];
    }
}

- (void)attachUploadFinished:(NSNotification *)notification {
    NSArray *attachIDArr = notification.object;
    attachIDArr = [attachIDArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 integerValue] >= [obj2 integerValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    NSString *plainString = [PostDataManager plainStringConvertedFromAttributedString:[data shareInstance].postQuestionDetail andAttachIDArray:attachIDArr];
    
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
    
    NSDictionary *parameters = @{@"question_content": self.questionView.text,
                                 @"question_detail": plainString,
                                 @"topics": topicsStr,
                                 @"attach_access_key": [data shareInstance].attachAccessKey,
                                 @"anonymous": [NSNumber numberWithInteger:isAnonymousControl.selectedSegmentIndex]};
    [PostDataManager postQuestionWithParameters:parameters success:^(NSString *questionId) {
        [MsgDisplay dismiss];
        [MsgDisplay showSuccessMsg:[NSString stringWithFormat:@"问题发布成功！"]];
    
        for (UIViewController *navVc in self.navigationController.presentingViewController.tabBarController.viewControllers) {
            if ([navVc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nVC = (UINavigationController *)navVc;
                if ([nVC.viewControllers[0] isKindOfClass:[HomeViewController class]]) {
                    HomeViewController *hVC = (HomeViewController *)nVC.viewControllers[0];
                    hVC.shouldRefresh = YES;
                }
            }
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [data shareInstance].postQuestionDetail = nil;
        [data shareInstance].attachAccessKey = @"";
    } failure:^(NSString *errStr) {
        [MsgDisplay dismiss];
        [MsgDisplay showErrorMsg:errStr];
    }];
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

- (IBAction)cancelModal {
    if (self.questionView.attributedText.length == 0 && [data shareInstance].postQuestionDetail.length == 0) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *saveController = [UIAlertController alertControllerWithTitle:@"草稿" message:@"还有未发布的内容\n是否要保存为草稿？" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [wjDatabaseManager saveQuestionDraftWithTitle:self.questionView.text detail:[data shareInstance].postQuestionDetail topicsArray:[topicsArr copy] attachAccessKey:[data shareInstance].attachAccessKey anonymous:isAnonymousControl.selectedSegmentIndex finishBlock:^{
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                [MsgDisplay showSuccessMsg:@"草稿保存成功"];
            }];
        }];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"不保存" style: UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        [saveController addAction:cancelAction];
        [saveController addAction:saveAction];
        [saveController addAction:dismissAction];
        [saveController setModalPresentationStyle:UIModalPresentationPopover];
        [saveController.popoverPresentationController setSourceView:self.view];
        [saveController.popoverPresentationController setSourceRect:self.view.frame];
        [saveController.popoverPresentationController setPermittedArrowDirections:UIPopoverArrowDirectionAny];
        [self presentViewController:saveController animated:YES completion:nil];
    }
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
