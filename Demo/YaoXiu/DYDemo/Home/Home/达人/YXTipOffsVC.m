//
//  YXFansVC.m
//  YaoXiu
//
//  Created by MAC on 2020/4/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "YXTipOffsVC.h"
#import "YXNormalCell.h"
#import "LGTextView.h"

@interface YXTipOffsVC()

@end

@implementation YXTipOffsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navTitle = @"视频举报";
    
    
    self.dataArr = @[@"垃圾营销",@"涉黄信息",@"不实信息",@"违法犯罪",@"造谣传谣涉嫌欺诈",@"侮辱谩骂",@"未成年不当行为",@"侵犯权益",@"政治敏感"].mutableCopy;
    self.tableView.backgroundColor = ColorBlack;
    self.tableView.frame = CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight-SafeAreaTopHeight-100-60);
    self.view.backgroundColor = ColorBlack;

    LGTextView *textView = [[LGTextView alloc]init];
    textView.placeholder = @"请填写举报理由:";
    textView.placeholderColor = m_Color_gray(153);
    textView.textColor = m_Color_gray(153);
    textView.backgroundColor = ColorBlack;
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        makeBottomOffSet(self.view, -SafeAreaBottomHeight-44);
        make.width.offset(ScreenWidth-30);
        make.height.offset(100);
    }];
    
    ls_view(bottomLine, m_Color_gray(40), self.view, {
        make.left.offset(0);
        makeTopOffSet(textView, 0)
        make.right.offset(0);
        make.height.offset(1);
    })
    
    
    ls_button( commit, @"提交", m_FontPF_Regular_WithSize(14), m_Color_gray(233), @"", m_Color_gray(40), 0, self.view, {
        make.left.offset(0);
        makeBottomOffSet(self.view, -SafeAreaBottomHeight);
        make.width.offset(ScreenWidth);
        make.height.offset(44);
    }, {
        
    })
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.title = @"视频举报";
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma  mark  - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     YXNormalCell*cell = [YXNormalCell loadCode:tableView];
    
    [cell setTitle:self.dataArr[indexPath.row] subTitle:@"" arrowHidden:YES];
    [cell setSelectBackgroundColor:m_Color_gray(140)];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
