//
//  MyTopView.m
//  YaoXiu
//
//  Created by 伯爵 on 2019/12/25.
//  Copyright © 2019 GangMeiTanGongXu. All rights reserved.
//

#import "MyTopView.h"
#import "UserInfoViewController.h"

@implementation MyTopView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)userInfoBtnClick:(UIButton *)sender {
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc]init];
    [[[Singleton shardeManger]getCurrentVC].navigationController pushViewController:userInfoVC animated:YES];
}


@end
