//
//  LoginViewController.m
//  YaoXiu
//
//  Created by 伯爵 on 2020/2/18.
//  Copyright © 2020 GangMeiTanGongXu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "CodeViewController.h"
#import "ForgetPswViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *fImg;
@property (weak, nonatomic) IBOutlet UIButton *fBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sImg;
@property (weak, nonatomic) IBOutlet UIButton *sBtn;
@property (weak, nonatomic) IBOutlet UIView *pswView;
@property (weak, nonatomic) IBOutlet UIButton *forgetPswBtn;
@property (nonatomic ,assign)NSInteger index;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@property (weak, nonatomic) IBOutlet UIButton *wxLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqLoginBtn;


@end

@implementation LoginViewController

/**
 *    @brief    展示登录界面
 */
+(void)gw_showLoginVCWithCompletion:(void (^ __nullable)(void))completion{
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    GKDYNavigationController *nav = [[GKDYNavigationController alloc]initWithRootViewController:loginVC];
    [[self currentViewController] presentViewController:nav animated:YES completion:completion];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 100;
    self.wxLoginBtn.hidden = YES;
    self.qqLoginBtn.hidden = YES;
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    //目前只开发手机验证码登录
    [self chooseBtnClick:self.sBtn];
    
    self.phoneTF.text = @"17610240017";
}

- (IBAction)chooseBtnClick:(UIButton *)sender {
    self.index = sender.tag;
    if (sender.tag == 100) {
        m_ToastCenter(@"目前仅支持手机验证码登录")//目前只开发手机验证码登录
        return;
        self.fImg.image = [UIImage imageNamed:@"编组"];
        [self.fBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sImg.image = [UIImage imageNamed:@""];
        [self.sBtn setTitleColor:RGB(200, 197, 195) forState:UIControlStateNormal];
        self.pswView.hidden = NO;
        [self.forgetPswBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    }else{
        self.sImg.image = [UIImage imageNamed:@"编组"];
        [self.sBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.fImg.image = [UIImage imageNamed:@""];
        [self.fBtn setTitleColor:RGB(200, 197, 195) forState:UIControlStateNormal];
        self.pswView.hidden = YES;
        [self.forgetPswBtn setTitle:@"遇到问题" forState:UIControlStateNormal];
    }
}

- (IBAction)forGetPswBtnClick:(UIButton *)sender {
    ForgetPswViewController *forgetPswVC = [[ForgetPswViewController alloc]init];
    [self.navigationController pushViewController:forgetPswVC animated:YES];
}

- (IBAction)registerBtnClick:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    if ([self.forgetPswBtn.titleLabel.text isEqualToString:@"忘记密码"]) {
        //登录
        if (!self.phoneTF.text.length) {
            return [self showHint:@"请输入正确的账号"];
        }
        if (!self.pswTF.text.length){
            return [self showHint:@"请输入密码"];
        }
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setValue:self.phoneTF.text forKey:@"phone_number"];
        [param setValue:self.pswTF.text forKey:@"password"];

        NSString *jsonStr = [[Singleton shardeManger]convertToJsonData:param];
        [[DataRequest Manager] postBossDemoWithUrl:[NSString stringWithFormat:@"%@login",base_url] param:jsonStr success:^(NSDictionary *dict) {
            if ([dict[@"errorCode"]intValue] == 0) {
//                [[NSUserDefaults standardUserDefaults] setObject:dict[@"data"][@"token"] forKey:@"user_token"];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self showHint:dict[@"message"]];
            }
        } fail:^(NSError *error) {
             NSLog(@"%@",error);
        }];
        
    }else{
        
        if (!self.phoneTF.text.length) {
            return [self showHint:@"请输入正确的账号"];
        }
        CodeViewController *codeVC = [[CodeViewController alloc]init];
        codeVC.titleStr = @"登录";
        codeVC.phoneStr = self.phoneTF.text;
        [self.navigationController pushViewController:codeVC animated:YES];
    }
}

@end
