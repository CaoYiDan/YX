//
//  GKDYMessageViewController.m
//  GKDYVideo
//
//  Created by gaokun on 2019/5/8.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDYMessageViewController.h"

@interface GKDYMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GKDYMessageViewController
{
    UITableView *_tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navBackgroundColor = [UIColor clearColor];
    self.gk_navShadowColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    self.gk_navTitle = @"消息";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    return;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.backgroundColor = ColorWhite;
    [self.view addSubview:_tableView];
    
//    MJRefreshNormalHeader *header =

//    header.ignoredScrollViewContentInsetTop = (50);

    _tableView.mj_footer   = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"fdf"];
    cell.backgroundColor = ColorBlue;
    return cell;
}
@end
