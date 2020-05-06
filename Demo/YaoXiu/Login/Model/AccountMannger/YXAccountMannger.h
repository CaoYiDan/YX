//
//  YXAccountMannger.h
//  XueYouHui_User
//
//  Created by ourslook on 2018/5/15.
//  Copyright © 2018年 Ourslook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YXUserModel.h"

/** 通知接受 */
#define AccountMannger_userInfoDidChangeNotification(...) [[[NSNotificationCenter defaultCenter] rac_addObserverForName:AccountUserInfoDidChangeNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {\
__VA_ARGS__\
}]

@interface YXAccountMannger : NSObject


/**
 *    @brief    设置用户信息
 */
+(void)setUserInfo:(YXUserModel*)userInfo;
#define AccountMannger_setUserInfo(object) [YXAccountMannger setUserInfo:object]

/**
 *    @brief    获取用户信息
 */
+(YXUserModel*)getUserInfo;
#define AccountMannger_userInfo [YXAccountMannger getUserInfo]

/**
 *    @brief    更新用户信息
 *
 *    @param     value     值  如果是double类型需转换成NSNumber类型
 *    @param     key     键  需要更新的值
 *    @param     notice     是否发送用户信息更新通知
 */
+(void)updateUserInfoValue:(id)value forKey:(NSString*)key notice:(BOOL)notice;
#define AccountMannger_updateUserInfo(value,key) [YXAccountMannger updateUserInfoValue:(value) forKey:(key) notice:YES]
#define AccountMannger_updateUserInfoNoNotice(value,key) [YXAccountMannger updateUserInfoValue:(value) forKey:(key) notice:NO]

/**
 *    @brief    清除用户信息
 */
+(void)removeUserInfo;
#define AccountMannger_removeUserInfo [YXAccountMannger removeUserInfo]

/**
 *    @brief    用户是否登录
 */
+(BOOL)isLogin;
#define AccountMannger_isLogin [YXAccountMannger isLogin]

@end
