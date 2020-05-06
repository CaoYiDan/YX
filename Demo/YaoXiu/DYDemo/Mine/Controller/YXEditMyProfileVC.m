//
//  YXEditMyProfileVC.m
//  YaoXiu
//
//  Created by MAC on 2020/4/17.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "YXEditMyProfileVC.h"
#import "YXEditIconView.h"
#import "YXNormalCell.h"

@interface YXEditMyProfileVC ()
/** header */
@property (nonatomic, strong) YXEditIconView *headerView;
@end

@implementation YXEditMyProfileVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    self.gk_navTitle = @"编辑资料";
    
    self.dataArr = @[
        @{@"name":@"昵称",@"value":@"test",@"arrowHidden":@(0)},
        @{@"name":@"吆秀号",@"value":@"test",@"arrowHidden":@(0)},
        @{@"name":@"二维码",@"value":@"test",@"arrowHidden":@(0)},
        @{@"name":@"个人简介",@"value":@"test",@"arrowHidden":@(0)},
        @{@"name":@"性别",@"value":@"test",@"arrowHidden":@(0)},
        @{@"name":@"生日",@"value":@"test",@"arrowHidden":@(0)},
        @{@"name":@"地区",@"value":@"test",@"arrowHidden":@(0)},
    ].mutableCopy;
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = ColorBlack;
}

#pragma  mark  - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YXNormalCell *cell = [YXNormalCell loadCode:tableView];
    NSDictionary *dic = self.dataArr[indexPath.row];
    [cell setTitle:dic[@"name"] subTitle:dic[@"value"] arrowHidden:[dic[@"arrowHidden"] boolValue]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (YXEditIconView *)headerView{
    if (!_headerView) {
        _headerView = [[YXEditIconView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/16*9)];
    }
    return _headerView;
}


@end
