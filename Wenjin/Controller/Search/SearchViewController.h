//
//  SearchViewController.h
//  Wenjin
//
//  Created by Qin Yubo on 15/10/20.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UIView *veView;
@property (nonatomic) NSInteger searchType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

- (IBAction)segmentedSelected:(id)sender;
- (IBAction)search:(id)sender;

@end
