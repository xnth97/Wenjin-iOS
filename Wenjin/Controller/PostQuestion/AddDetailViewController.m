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
#import "ALActionBlocks.h"
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
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    detailTextView.font = [UIFont systemFontOfSize:17.0];
    detailTextView.text = [data shareInstance].postQuestionDetail;
    [self.view addSubview:detailTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [detailTextView becomeFirstResponder];
    
    UIToolbar *accessoryToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    accessoryToolbar.barStyle = UIBarStyleDefault;
    accessoryToolbar.translucent = YES;
    
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
    [accessoryToolbar setItems:@[flexibleSpace, flexibleSpace, addImageBtn]];
    detailTextView.inputAccessoryView = accessoryToolbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [detailTextView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight)];
}

- (void)dealloc {
    //使用通知中心后必须重写dealloc方法,进行释放(ARC)(非ARC还需要写上[super dealloc];)
    //removeObserver和 addObserver相对应.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done {
    [data shareInstance].postQuestionDetail = self.detailTextView.text;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
            [PostDataManager uploadAttachFile:picData attachType:@"question" success:^(NSString *attachId) {
                [MsgDisplay dismiss];
                NSUInteger loc = detailTextView.selectedRange.location;
                detailTextView.text = [NSString stringWithFormat:@"%@\n[attach]%@[/attach]\n%@", [detailTextView.text substringToIndex:loc], attachId, [detailTextView.text substringFromIndex:loc]];
                [detailTextView becomeFirstResponder];
            } failure:^(NSString *errStr) {
                [MsgDisplay dismiss];
                [MsgDisplay showErrorMsg:errStr];
                [detailTextView becomeFirstResponder];
            }];
        });
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
