//
//  ProfileEditTableViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "ProfileEditTableViewController.h"
#import "ProfileEditForm.h"

@interface ProfileEditTableViewController ()

@end

@implementation ProfileEditTableViewController

@synthesize formController;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    formController = [[FXFormController alloc] init];
    formController.tableView = self.tableView;
    formController.delegate = self;
    formController.form = [[ProfileEditForm alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
