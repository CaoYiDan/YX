//
//  YXFollowSVC.m
//  YaoXiu
//
//  Created by MAC on 2020/4/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "YXFollowSListVC.h"
#import "YXFansCell.h"
@interface YXFollowSListVC ()

@end

@implementation YXFollowSListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    
    self.tableView.backgroundColor = ColorBlack;
    [self.tableView reloadData];
    [self requsetData];
//    self.gk_navigationBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
//    self.gk_navigationBar.hidden = YES;
//    self.gk_navBackgroundColor = [UIColor clearColor];
}


-(void)requsetData{
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    NSMutableDictionary *pageDic = @{}.mutableCopy;
    [pageDic setObject:@(0) forKey:@"index"];
    [pageDic setObject:@(20) forKey:@"size"];
       
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:dataDic forKey:@"data"];
    [dic setObject:@"list_friends" forKey:@"action"];
    [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];
    
    [[HttpRequest sharedClient]postWithUrl:YXUserFollow body:dic success:^(NSDictionary *response) {
        self.dataArr = [YXUserModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma  mark  - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXFansCell *cell = [YXFansCell loadCode:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
