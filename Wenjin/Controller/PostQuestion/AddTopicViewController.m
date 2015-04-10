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
    UIAlertController *topicInputAlert;
    NSMutableArray *topicsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    topicsArr = [[NSMutableArray alloc]initWithArray:[data shareInstance].postQuestionTopics];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
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
    topicInputAlert = [UIAlertController alertControllerWithTitle:@"话题" message:@"请输入话题" preferredStyle:UIAlertControllerStyleAlert];
    [topicInputAlert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *inputTopicAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *topicField = topicInputAlert.textFields[0];
        if ([topicField.text isEqualToString:@""]) {
            [MsgDisplay showErrorMsg:@"话题不能为空"];
        } else {
            [topicsArr addObject:topicField.text];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [topicInputAlert addAction:cancelAction];
    [topicInputAlert addAction:inputTopicAction];
    [self presentViewController:topicInputAlert animated:YES completion:nil];
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
