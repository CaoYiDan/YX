//
//  YXFansVC.m
//  YaoXiu
//
//  Created by MAC on 2020/4/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "YXFansVC.h"
#import "YXFansCell.h"

@interface YXFansVC ()

@end

@implementation YXFansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = ColorBlack;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.gk_navigationBar.hidden = YES;
}

#pragma  mark  - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXFansCell *cell = [YXFansCell loadCode:tableView];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
