//
//  YXAppIntroductionVC.m
//  YaoXiu
//
//  Created by MAC on 2020/4/22.
//  Copyright © 2020 Tencent. All rights reserved.
//
#import "YXNormalCell.h"
#import "YXAppIntroductionVC.h"

@interface YXAppIntroductionVC ()

@end

@implementation YXAppIntroductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.dataArr = @[@{@"name":@"版本",@"value":@"v1.1",@"hidden":@(1)},@{@"name":@"联系客服",@"value":@"17610240017",@"hidden":@(0)},@{@"name":@"联系电话",@"value":@"17610240017",@"hidden":@(0)},@{@"name":@"举报电话",@"value":@"17610240017",@"hidden":@(0)}].mutableCopy;
    
    [self setHeader];
}

#pragma  mark  - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXNormalCell *cell = [YXNormalCell loadCode:tableView];
    NSDictionary *dic = self.dataArr[indexPath.row];
    [cell setTitle:dic[@"name"] subTitle:dic[@"value"] arrowHidden:[dic[@"hidden"] boolValue]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)setHeader{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
    ls_imageView(appImg, @"", header, {
        make.centerX.offset(0);
        makeTopOffSet(header, 30);
        make.width.offset(94);
        make.height.offset(94);
    })
    
    ls_label(appName, @"吆秀", m_Color_RGB(254, 254, 254), m_FontPF_Regular_WithSize(17),ColorBlack, NSTextAlignmentCenter, header, {
        make.centerX.offset(0);
        makeTopOffSet(appImgImg.mas_bottom, 10);
        make.width.offset(100);
        make.height.offset(30);
    })
    
    self.tableView.tableHeaderView = header;
}
@end
