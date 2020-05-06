//
//  BaseTableViewController.h
//  Pos
//
//  Created by mac on 2018/8/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseViewController.h"
#import "GKDYBaseViewController.h"

@interface GKBaseTableViewVC :GKDYBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/**  */
@property (nonatomic, strong) NSMutableArray *dataArr;

- (void)createTableView;

@end
