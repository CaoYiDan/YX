//
//  LoginViewController.h
//  YaoXiu
// a
//  Created by 伯爵 on 2020/2/18.
//  Copyright © 2020 GangMeiTanGongXu. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : BaseViewController
/**
 *    @brief    展示登录界面
 */
+(void)gw_showLoginVCWithCompletion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
