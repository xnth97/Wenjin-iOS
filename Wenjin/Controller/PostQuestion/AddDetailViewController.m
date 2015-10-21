//
//  AddDetailViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "AddDetailViewController.h"
#import "data.h"
#import "wjStringProcessor.h"
#import "wjAppearanceManager.h"
#import "BlocksKit+UIKit.h"
#import "PostDataManager.h"
#import "MsgDisplay.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface AddDetailViewController ()

@end

@implementation AddDetailViewController

@synthesize detailTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:[wjAppearanceManager mainTintColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    detailTextView.font = [UIFont systemFontOfSize:17.0];
    detailTextView.attributedText = [data shareInstance].postQuestionDetail;
    [self.view addSubview:detailTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [detailTextView becomeFirstResponder];
    
    UIToolbar *accessoryToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    accessoryToolbar.barStyle = UIBarStyleDefault;
    accessoryToolbar.translucent = YES;
    
    UIBarButtonItem *addImageBtn = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"insertPic"] landscapeImagePhone:nil style: UIBarButtonItemStylePlain handler:^(id weakSender) {
        UIAlertController *uploadController = [UIAlertController alertControllerWithTitle:@"上传图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
//                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                picker.modalPresentationStyle = UIModalPresentationFormSheet;
                [self presentViewController:picker animated:YES completion:nil];
            } else {
                [MsgDisplay showErrorMsg:@"相机不可用"];
            }
        }];
        UIAlertAction *uploadAction = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
//                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                picker.modalPresentationStyle = UIModalPresentationFormSheet;
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
    [accessoryToolbar setItems:@[flexibleSpace, flexibleSpace, addImageBtn]];
    detailTextView.inputAccessoryView = accessoryToolbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [detailTextView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight - 64)];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        [detailTextView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 44 - 64)];
    }];
}

- (void)dealloc {
    //使用通知中心后必须重写dealloc方法,进行释放(ARC)(非ARC还需要写上[super dealloc];)
    //removeObserver和 addObserver相对应.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)cancel {
    if ([detailTextView.text isEqualToString:@""]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *cancelAlert = [UIAlertController alertControllerWithTitle:@"是否要保存您的内容更改？" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [data shareInstance].postQuestionDetail = detailTextView.attributedText;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        [cancelAlert addAction:cancelAction];
        [cancelAlert addAction:saveAction];
        [cancelAlert addAction:dismissAction];
        [cancelAlert.popoverPresentationController setPermittedArrowDirections:0];
        [cancelAlert.popoverPresentationController setSourceView:self.view];
        [cancelAlert.popoverPresentationController setSourceRect:self.view.frame];
        [self presentViewController:cancelAlert animated:YES completion:nil];
    }
}

- (IBAction)done {
    [data shareInstance].postQuestionDetail = self.detailTextView.attributedText;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
        [MsgDisplay showErrorMsg:@"Type unsupported"];
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (img.size.width > 600) {
            CGSize newSize = CGSizeMake(600, 600 * img.size.height / img.size.width);
            UIGraphicsBeginImageContext(newSize);
            [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
//        NSData *picData = UIImageJPEGRepresentation(img, 0.5);
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageWithCGImage:img.CGImage scale:img.size.width / (detailTextView.frame.size.width - 10) orientation:UIImageOrientationUp];
        NSAttributedString *attrStrWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        NSUInteger loc = detailTextView.selectedRange.location;
        [detailTextView.textStorage insertAttributedString:attrStrWithImage atIndex:loc];
        [detailTextView becomeFirstResponder];
        [detailTextView setSelectedRange:NSMakeRange(loc + 1, 0)];
        [detailTextView.textStorage addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0]} range:NSMakeRange(0, detailTextView.attributedText.length)];
        
//        [MsgDisplay showLoading];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [PostDataManager uploadAttachFile:picData attachType:@"question" success:^(NSString *attachId) {
//                [MsgDisplay dismiss];
//                NSUInteger loc = detailTextView.selectedRange.location;
//                detailTextView.text = [NSString stringWithFormat:@"%@\n[attach]%@[/attach]\n%@", [detailTextView.text substringToIndex:loc], attachId, [detailTextView.text substringFromIndex:loc]];
//                [detailTextView becomeFirstResponder];
//            } failure:^(NSString *errStr) {
//                [MsgDisplay dismiss];
//                [MsgDisplay showErrorMsg:errStr];
//                [detailTextView becomeFirstResponder];
//            }];
//        });
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [detailTextView becomeFirstResponder];
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
