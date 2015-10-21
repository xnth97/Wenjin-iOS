//
//  DraftTableViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/4.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "DraftTableViewController.h"
#import <Realm/Realm.h>
#import "DraftTableViewCell.h"
#import "AnswerDraft.h"
#import "QuestionDraft.h"
#import "wjAppearanceManager.h"
#import "PostQuestionViewController.h"
#import "PostAnswerViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "wjDatabaseManager.h"

#define draftTypeQuestion 0
#define draftTypeAnswer 1

@interface DraftTableViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (strong) RLMNotificationToken *token;

@end

@implementation DraftTableViewController {
    RLMResults *dataArr;
    NSMutableArray *dataInTable;
    UISegmentedControl *segmentedControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"realmDataHasBeenCleared"] == nil) {
        [wjDatabaseManager removeRealmFile];
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"realmDataHasBeenCleared"];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.estimatedRowHeight = 66;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    dataInTable = [[NSMutableArray alloc] init];
    
    segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"问题", @"答案"]];
    [segmentedControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl setFrame:CGRectMake(0, 0, 150, segmentedControl.frame.size.height)];
    [self.navigationItem setTitleView:segmentedControl];
    
    _token = [[RLMRealm defaultRealm] addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
        if (segmentedControl.selectedSegmentIndex == draftTypeQuestion) {
            dataArr = [QuestionDraft allObjects];
        } else if (segmentedControl.selectedSegmentIndex == draftTypeAnswer) {
            dataArr = [AnswerDraft allObjects];
        }
    }];
    
    [self updateTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTable {
    [dataInTable removeAllObjects];
    if (segmentedControl.selectedSegmentIndex == draftTypeQuestion) {
        dataArr = [QuestionDraft allObjects];
        for (QuestionDraft *tmp in dataArr) {
            [dataInTable addObject:@{@"time": ({
                                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                        [dateFormatter stringFromDate:tmp.time];
                                    }),
                                     @"content": tmp.questionTitle}];
        }
        [self.tableView reloadData];
    } else if (segmentedControl.selectedSegmentIndex == draftTypeAnswer) {
        dataArr = [AnswerDraft allObjects];
        for (AnswerDraft *tmp in dataArr) {
            [dataInTable addObject:@{@"time": ({
                                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                        [dateFormatter stringFromDate:tmp.time];
                                    }),
                                     @"content": ((NSAttributedString *)[NSKeyedUnarchiver unarchiveObjectWithData:tmp.answerContent]).string}];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - EmptyDataSet 

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无保存的草稿";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"desperateSmile"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataInTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DraftTableViewCell *cell = (DraftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"simpleIdentifier"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DraftTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *tmp = dataInTable[row];
    cell.dateLabel.text = tmp[@"time"];
    cell.contentLabel.text = tmp[@"content"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (segmentedControl.selectedSegmentIndex == draftTypeQuestion) {
        QuestionDraft *draft = dataArr[row];
        PostQuestionViewController *postQuestionViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PostQuestionViewController"];
        postQuestionViewController.draftToBeLoaded = draft;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postQuestionViewController];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (segmentedControl.selectedSegmentIndex == draftTypeAnswer) {
        AnswerDraft *draft = dataArr[row];
        PostAnswerViewController *postAnswerController = [[PostAnswerViewController alloc] init];
        postAnswerController.draftToBeLoaded = draft;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postAnswerController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSUInteger row = [indexPath row];
        [dataInTable removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        RLMObject *dataToBeDeleted = dataArr[row];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:dataToBeDeleted];
        [realm commitWriteTransaction];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
