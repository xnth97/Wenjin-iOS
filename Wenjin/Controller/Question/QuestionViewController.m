//
//  QuestionViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionDataManager.h"
#import "MsgDisplay.h"
#import "wjStringProcessor.h"
#import "UserViewController.h"
#import "AnswerViewController.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController {
    NSMutableArray *questionAnswersData;
    NSDictionary *questionInfo;
    NSMutableArray *questionTopics;
}

@synthesize questionTableView;
@synthesize questionId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.questionTableView.dataSource = self;
    self.questionTableView.delegate = self;
    self.questionTableView.tableFooterView = [[UIView alloc]init];
    
    [QuestionDataManager getQuestionDataWithID:questionId success:^(NSDictionary *_questionInfo, NSArray *_questionAnswers, NSArray *_questionTopics, NSString *_answerCount) {
        questionInfo = _questionInfo;
        questionTopics = [[NSMutableArray alloc]initWithArray:_questionTopics];
        questionAnswersData = [[NSMutableArray alloc]initWithArray:_questionAnswers];
        
        self.title = [NSString stringWithFormat:@"共 %@ 回答", _answerCount];
        
        QuestionHeaderView *headerView = [[QuestionHeaderView alloc]initWithQuestionInfo:questionInfo andTopics:questionTopics];
        questionTableView.tableHeaderView = headerView;
        [questionTableView reloadData];
        
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [questionTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    return [self heightOfLabelWithTextString:[wjStringProcessor processAnswerDetailString:(questionAnswersData[row])[@"answer_content"]]] + 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [questionAnswersData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    QuestionAnswerTableViewCell *cell = (QuestionAnswerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QuestionAnswerTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    NSDictionary *tmp = questionAnswersData[row];
    cell.userNameLabel.text = tmp[@"user_name"];
    cell.answerContentLabel.text = [wjStringProcessor processAnswerDetailString:tmp[@"answer_content"]];
    cell.agreeCountLabel.text = [tmp[@"agree_count"] stringValue];
    cell.userAvatarView.tag = row;
    cell.delegate = self;
    return cell;
}

- (CGFloat)heightOfLabelWithTextString:(NSString *)textString {
    CGFloat width = self.view.frame.size.width;
    
    UILabel *gettingSizeLabel = [[UILabel alloc]init];
    gettingSizeLabel.text = textString;
    gettingSizeLabel.font = [UIFont systemFontOfSize:15];
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maxSize = CGSizeMake(width, 1000.0);
    
    CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    AnswerViewController *aVC = [[AnswerViewController alloc]initWithNibName:@"AnswerViewController" bundle:nil];
    aVC.answerId = (questionAnswersData[row])[@"answer_id"];
    [self.navigationController pushViewController:aVC animated:YES];
}

// Question Push User Delegate
- (void)pushUserControllerWithRow:(NSUInteger)row {
    UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    uVC.userId = [(questionAnswersData[row])[@"uid"] stringValue];
    [self.navigationController pushViewController:uVC animated:YES];
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
