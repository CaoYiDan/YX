//
//  YXLoginManager.m
//  YaoXiu
//
//  Created by MAC on 2020/4/1.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "TCLoginParam.h"
#import "YXLoginManager.h"
#import "TCLoginModel.h"
#import "TCLoginViewController.h"

#import "TCUtil.h"

#import "TCRegisterViewController.h"
#import "TCRegisterViewController.h"
#import "TCUserInfoModel.h"
#import <UGCKit/UGCKit.h>
@implementation YXLoginManager
{
    TCLoginParam *_loginParam;
}

- (void)logionWithAccount:(NSString *)account password:(NSString *)password{
     _loginParam = [TCLoginParam shareInstance];
}

@end
