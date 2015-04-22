//
//  PostAnswerViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "PostAnswerViewController.h"
#import "ALActionBlocks.h"
#import "PostDataManager.h"
#import "MsgDisplay.h"
#import "QuestionViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "data.h"
#import "NYSegmentedControl.h"
#import "wjAppearanceManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PostAnswerViewController ()

@end

@implementation PostAnswerViewController {
    NYSegmentedControl *isAnonymousControl;
}

@synthesize answerView;
@synthesize questionId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加回答";
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    [data shareInstance].attachAccessKey = [self MD5FromNowDate];
    
    isAnonymousControl = [[NYSegmentedControl alloc]initWithItems:@[@"不匿名", @"匿名"]];
    isAnonymousControl.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    isAnonymousControl.segmentIndicatorBackgroundColor = [UIColor whiteColor];
    isAnonymousControl.segmentIndicatorInset = 0.0f;
    isAnonymousControl.titleTextColor = [UIColor lightGrayColor];
    isAnonymousControl.selectedTitleTextColor = [wjAppearanceManager mainTintColor];
    [isAnonymousControl sizeToFit];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel block:^(id weakSender) {
        if ([answerView.text isEqualToString:@""]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertController *cancelAlert = [UIAlertController alertControllerWithTitle:@"呃..." message:@"确定要放弃正在输入的内容吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            [cancelAlert addAction:cancelAction];
            [cancelAlert addAction:dismissAction];
            [self presentViewController:cancelAlert animated:YES completion:nil];
        }
    }];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone block:^(id weakSender) {
        [MsgDisplay showLoading];
        NSDictionary *parameters = @{@"question_id": questionId,
                                     @"answer_content": answerView.text,
                                     @"attach_access_key": [data shareInstance].attachAccessKey,
                                     @"anonymous": [NSNumber numberWithInteger:isAnonymousControl.selectedSegmentIndex],
                                     @"auto_focus": [NSNumber numberWithInteger: [[NSUserDefaults standardUserDefaults] integerForKey:@"autoFocus"]]};
        [PostDataManager postAnswerWithParameters:parameters success:^(NSString *answerId) {
            [MsgDisplay dismiss];
            [MsgDisplay showSuccessMsg:@"答案添加成功！"];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                // 回调以后刷新 QuestionViewController
                [self.navigationController.presentingViewController setValue:@YES forKey:@"shouldRefresh"];
            }];
            
        } failure:^(NSString *errorStr) {
            [MsgDisplay dismiss];
            [MsgDisplay showErrorMsg:errorStr];
        }];
        
    }];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    
    answerView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    answerView.font = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:answerView];
    
    UIToolbar *accessoryToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    accessoryToolbar.barStyle = UIBarStyleDefault;
    accessoryToolbar.translucent = YES;
    
    UIBarButtonItem *anonymousBtn = [[UIBarButtonItem alloc]initWithCustomView:isAnonymousControl];
    UIBarButtonItem *addImageBtn = [[UIBarButtonItem alloc]initWithTitle:@"添加图片" style:UIBarButtonItemStylePlain block:^(id weakSender) {
        
        UIAlertController *uploadController = [UIAlertController alertControllerWithTitle:@"上传图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
                //picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
            } else {
                [MsgDisplay showErrorMsg:@"相机不可用"];
            }
        }];
        UIAlertAction *uploadAction = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
                //picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
            } else {
                [MsgDisplay showErrorMsg:@"图库不可用"];
            }
        }];
        [uploadController addAction:cancelAction];
        [uploadController addAction:photoAction];
        [uploadController addAction:uploadAction];
        [uploadController setModalPresentationStyle:UIModalPresentationPopover];
        [uploadController.popoverPresentationController setPermittedArrowDirections:0];
        [uploadController.popoverPresentationController setSourceView:self.view];
        [uploadController.popoverPresentationController setSourceRect:self.view.frame];
        [self presentViewController:uploadController animated:YES completion:nil];
        
    }];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [accessoryToolbar setItems:@[anonymousBtn, flexibleSpace, addImageBtn]];
    answerView.inputAccessoryView = accessoryToolbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [answerView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [answerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight)];
    }];
}

- (void)keyboardWillHide {
    [UIView animateWithDuration:0.3 animations:^{
        [answerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

// Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
        [MsgDisplay showErrorMsg:@"Type unsupported"];
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *picData = UIImageJPEGRepresentation(img, 0.5);
        [picker dismissViewControllerAnimated:YES completion:nil];
        [MsgDisplay showLoading];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [PostDataManager uploadAttachFile:picData attachType:@"answer" success:^(NSString *attachId) {
                [MsgDisplay dismiss];
                NSUInteger loc = answerView.selectedRange.location;
                answerView.text = [NSString stringWithFormat:@"%@\n[attach]%@[/attach]\n%@", [answerView.text substringToIndex:loc], attachId, [answerView.text substringFromIndex:loc]];
                [answerView becomeFirstResponder];
            } failure:^(NSString *errStr) {
                [MsgDisplay dismiss];
                [MsgDisplay showErrorMsg:errStr];
                [answerView becomeFirstResponder];
            }];
        });
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [answerView becomeFirstResponder];
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
