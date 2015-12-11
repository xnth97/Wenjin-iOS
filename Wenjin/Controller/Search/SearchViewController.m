//
//  SearchViewController.m
//  Wenjin
//
//  Created by Qin Yubo on 15/10/20.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDataManager.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MsgDisplay.h"
#import "SVPullToRefresh.h"
#import "SearchCell.h"
#import "UserListTableViewCell.h"
#import "SearchQuestionTableViewCell.h"
#import "BlocksKit.h"
#import "QuestionViewController.h"
#import "UserViewController.h"
#import "TopicViewController.h"

#define SEARCH_TYPE_QUESTIONS 0
#define SEARCH_TYPE_TOPICS 1
#define SEARCH_TYPE_USERS 2

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@end

@implementation SearchViewController {
    NSMutableArray *rowsData;
    NSInteger currentPage;
    NSString *searchString;
}

@synthesize searchTextField;
@synthesize typeSegmentedControl;
@synthesize resultsTableView;
@synthesize veView;
@synthesize searchType;
@synthesize bottomConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    typeSegmentedControl.selectedSegmentIndex = searchType;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [searchTextField becomeFirstResponder];
    resultsTableView.tableHeaderView = ({
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40 + 64)];
        headerView;
    });
    resultsTableView.tableFooterView = [UIView new];
    [veView addSubview:({
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, 1024, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        line;
    })];
    
//    resultsTableView.rowHeight = 56;
    
    rowsData = [[NSMutableArray alloc] init];
    searchString = @"";
    
    __weak SearchViewController *weakSelf = self;
    [resultsTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf nextPage];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [searchTextField resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)segmentedSelected:(id)sender {
    UISegmentedControl *senderSegmented = (UISegmentedControl *)sender;
    self.searchType = senderSegmented.selectedSegmentIndex;
    if (searchTextField.text.length > 0) {
        [self search:searchTextField];
    } else {
        [rowsData removeAllObjects];
        [resultsTableView reloadData];
    }
}

- (IBAction)search:(id)sender {
    currentPage = 1;
    [rowsData removeAllObjects];
    [resultsTableView reloadData];
    UITextField *txtField = (UITextField *)sender;
    if (txtField.text.length > 0) {
        searchString = txtField.text;
        [txtField resignFirstResponder];
        [MsgDisplay dismiss];
        [MsgDisplay showLoading];
        [self getSearchData];
    } else {
        [MsgDisplay dismiss];
        [MsgDisplay showErrorMsg:@"请输入搜索关键字"];
    }
}

#pragma mark - Private Methods

- (void)nextPage {
    currentPage ++;
    [self getSearchData];
}

- (void)getSearchData {
    NSInteger typeMarker = searchType; // To avoid problems caused by multi-threads.
    [SearchDataManager getSearchDataWithQuery:searchString type:searchType page:currentPage success:^(NSArray *_rowsData) {
        if (searchType == typeMarker) {
            if (currentPage == 1) {
                [MsgDisplay dismiss];
                [rowsData removeAllObjects];
                rowsData = [_rowsData mutableCopy];
                [resultsTableView reloadData];
                [resultsTableView.infiniteScrollingView stopAnimating];
            } else {
                if (_rowsData.count == 0) {
                    if (rowsData.count <= 10) {
                        [MsgDisplay dismiss];
                        [resultsTableView reloadData];
                    } else {
                        [MsgDisplay dismiss];
                        [MsgDisplay showErrorMsg:@"已到最后一页"];
                    }
                } else {
                    [MsgDisplay dismiss];
                    [rowsData addObjectsFromArray:_rowsData];
                    [resultsTableView reloadData];
                }
                [resultsTableView.infiniteScrollingView stopAnimating];
            }
        }
    } failure:^(NSString *errorStr) {
        [MsgDisplay showErrorMsg:errorStr];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [NSTimer bk_scheduledTimerWithTimeInterval:0.3 block:^(NSTimer *timer) {
        bottomConstraint.constant = 0;
    } repeats:NO];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [NSTimer bk_scheduledTimerWithTimeInterval:0.3 block:^(NSTimer *timer) {
        CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        bottomConstraint.constant = keyboardHeight;
    } repeats:NO];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (searchType == 0) {
        return 64;
    } else {
        return 56;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (searchType == 0) {
        return UITableViewAutomaticDimension;
    } else {
        return 56;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    SearchCell *tmp = rowsData[row];
    if ([tmp.type isEqualToString:@"users"]) {
        static NSString *cellIdentifier = @"reuseUserIdentifier";
        // 复用 UserListTableViewCell
        UserListTableViewCell *cell = (UserListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserListTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.userNameLabel.text = tmp.name;
        cell.userSigLabel.text = tmp.detail.signature;
        [cell loadImageWithURL:tmp.detail.avatarFile];
        return cell;
    } else if ([tmp.type isEqualToString:@"topics"]) {
        static NSString *cellIdentifier = @"reuseTopicIdentifier";
        // 复用 UserListTableViewCell
        UserListTableViewCell *cell = (UserListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserListTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.userNameLabel.text = tmp.name;
        cell.userSigLabel.text = tmp.detail.topicDescription;
        [cell loadImageWithURL:tmp.detail.topicPic];
        return cell;
    } else {
        // Questions
        static NSString *cellIdentifier = @"searchQuestionReuseIdentifier";
        SearchQuestionTableViewCell *cell = (SearchQuestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchQuestionTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.titleLabel.text = tmp.name;
        cell.focusCountLabel.text = [NSString stringWithFormat:@"%ld", tmp.detail.focusCount];
        cell.answerCountLabel.text = [NSString stringWithFormat:@"%ld", tmp.detail.answerCount];
//        [cell loadImageWithURL:tmp.detail.topicPic];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    SearchCell *tmp = rowsData[row];
    if ([tmp.type isEqualToString:@"users"]) {
        UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        uVC.userId = [NSString stringWithFormat:@"%ld", (long)tmp.uid];
        [self.navigationController pushViewController:uVC animated:YES];
    } else if ([tmp.type isEqualToString:@"topics"]) {
        TopicViewController *topicBestAnswer = [[TopicViewController alloc]initWithNibName:@"TopicViewController" bundle:nil];
        topicBestAnswer.topicId = [NSString stringWithFormat:@"%ld", (long)tmp.detail.topicId];
        [self.navigationController pushViewController:topicBestAnswer animated:YES];
    } else {
        QuestionViewController *qVC = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
        qVC.questionId = [NSString stringWithFormat:@"%ld", (long)tmp.searchId];
        [self.navigationController pushViewController:qVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = (searchTextField.text.length == 0) ? @"请键入内容以搜索" : @"未找到相应内容";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"searchIcon"];
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
