//
//  RegisterViewController.m
//  YaoXiu
//
//  Created by 伯爵 on 2020/2/26.
//  Copyright © 2020 GangMeiTanGongXu. All rights reserved.
//

#import "RegisterViewController.h"
#import "CodeViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(239, 237, 238);
    self.title = @"注册";
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerBtnClick:(UIButton *)sender {
    CodeViewController *codeVC = [[CodeViewController alloc]init];
    codeVC.titleStr = @"注册";
    [self.navigationController pushViewController:codeVC animated:YES];
}


@end
