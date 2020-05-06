//
//  CodeViewController.m
//  YaoXiu
//
//  Created by 伯爵 on 2020/3/23.
//  Copyright © 2020 GangMeiTanGongXu. All rights reserved.
//

#import "CodeViewController.h"
#import "HWTextCodeView.h"

@interface CodeViewController ()<HWTextCodeViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, weak) HWTextCodeView *codeView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@end

@implementation CodeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.titleLab.text = self.titleStr;
    [self setupView];
    [self requestData];
}

- (void)setupView{
    
    self.phoneLab.text = self.phoneStr;
    HWTextCodeView *code3View = [[HWTextCodeView alloc] initWithCount:6 margin:20];
    code3View.delegate = self;
    code3View.frame = CGRectMake(0, 0, ScreenWidth - 80, 40);
//    code3View.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:code3View];
    self.codeView = code3View;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)requestData{
    //获取验证码
    if (self.phoneStr.length!=11||[[Singleton shardeManger] checkTelNumber:self.phoneStr]==NO) {
        [self showHint:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:@"code" forKey:@"action"];
    NSMutableDictionary *paramm = [[NSMutableDictionary alloc]init];
    [paramm setValue:self.phoneStr forKey:@"user_name"];
    [param setValue:paramm forKey:@"data"];
    NSString *jsonStr = [[Singleton shardeManger]convertToJsonData:param];
    NSLog(@"======:%@",jsonStr);
    [[DataRequest Manager] postBossDemoWithUrl:[NSString stringWithFormat:@"%@sms",base_url] param:jsonStr success:^(NSDictionary *dict) {
        if ([dict[@"status"]intValue] == 200) {
            [self openCountdown];
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"data"][@"temp_user_id"] forKey:@"temp_user_id"];
            [self showHint:dict[@"message"]];
            //测试，后台返回code，自动填充code，
//            self.codeView.textField.text = NUMBER_TO_STRING(dict[@"data"][@"code"]);
//            [self getCodeStr:NUMBER_TO_STRING(dict[@"data"][@"code"])];
            
              [self showHint:[NSString stringWithFormat:@"吆秀：您的验证码为：%@",NUMBER_TO_STRING(dict[@"data"][@"code"])]];
        }else{
            
              [self showHint:dict[@"message"]];
        }
        
    } fail:^(NSError *error) {
        
         NSLog(@"%@",error);
        
    }];
}

- (void)getCodeStr:(NSString *)code{
    if (self.phoneStr.length!=11||[[Singleton shardeManger] checkTelNumber:self.phoneStr]==NO) {
        [self showHint:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:@"register_login" forKey:@"action"];
    NSMutableDictionary *paramm = [[NSMutableDictionary alloc]init];
    [paramm setValue:self.phoneStr forKey:@"user_name"];
    [paramm setValue:temp_user_id forKey:@"temp_user_id"];
    [paramm setValue:code forKey:@"code"];
    [param setValue:paramm forKey:@"data"];
    NSString *jsonStr = [[Singleton shardeManger]convertToJsonData:param];
    NSLog(@"======:%@",jsonStr);
    [[DataRequest Manager] postBossDemoWithUrl:[NSString stringWithFormat:@"%@user",base_url] param:jsonStr success:^(NSDictionary *dict) {
        
        if ([dict[@"status"]intValue] == 200) {

            m_UserDefaultSetObjectForKey(dict[@"data"][@"id"], Account_User_ID);
             m_UserDefaultSetObjectForKey(dict[@"data"][@"access_token"], Account_Access_Token);
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [self showHint:dict[@"error"]];
            
        }
    } fail:^(NSError *error) {
         NSLog(@"%@",error);
    }];
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tap{
    [self.codeView endEditing:YES];
}

-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%.2d秒后重新获取验证码", seconds] forState:UIControlStateNormal];
                //                [self.codeBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
