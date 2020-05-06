//
//  ForgetPswViewController.m
//  YaoXiu
//
//  Created by 伯爵 on 2020/3/23.
//  Copyright © 2020 GangMeiTanGongXu. All rights reserved.
//

#import "ForgetPswViewController.h"
#import "CodeViewController.h"

@interface ForgetPswViewController ()

@end

@implementation ForgetPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)forgetPswBtnClick:(UIButton *)sender {
    CodeViewController *codeVC = [[CodeViewController alloc]init];
    codeVC.titleStr = @"找回密码";
    [self.navigationController pushViewController:codeVC animated:YES];
}

@end
