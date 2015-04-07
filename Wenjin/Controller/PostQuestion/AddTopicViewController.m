//
//  AddTopicViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "AddTopicViewController.h"
#import "PostViewController.h"
#import "MsgDisplay.h"
#import "data.h"

@interface AddTopicViewController ()

@end

@implementation AddTopicViewController {
    UIAlertView *topicInputAlert;
    NSMutableArray *topicsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    topicsArr = [[NSMutableArray alloc]init];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelModal {
    [data shareInstance].postQuestionTopics = topicsArr;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addTopic {
    topicInputAlert = [[UIAlertView alloc]initWithTitle:@"话题" message:@"请输入话题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    topicInputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [topicInputAlert show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [topicsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleCellIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleCellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = topicsArr[row];
    
    return cell;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == topicInputAlert) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            return;
        } else {
            if (buttonIndex == 1) {
                UITextField *topicField = [alertView textFieldAtIndex:0];
                if ([topicField.text isEqualToString:@""]) {
                    [MsgDisplay showErrorMsg:@"话题不能为空"];
                } else {
                    [topicsArr addObject:topicField.text];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [topicsArr removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

@end
