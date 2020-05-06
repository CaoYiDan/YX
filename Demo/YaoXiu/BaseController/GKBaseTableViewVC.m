//
//  BaseTableViewController.m
//  Pos
//
//  Created by mac on 2018/8/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GKBaseTableViewVC.h"

@interface GKBaseTableViewVC ()

@end

@implementation GKBaseTableViewVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(236, 237, 238);
    self.dataArr = @[].mutableCopy;
    [self createTableView];
    
}

- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight-SafeAreaTopHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(236, 237, 238);
    [self.view addSubview:_tableView];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight, 0);
}


@end