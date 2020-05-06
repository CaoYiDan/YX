//
//  YXAccountMannger.m
//  XueYouHui_User
//
//  Created by ourslook on 2018/5/15.
//  Copyright © 2018年 Ourslook. All rights reserved.
//

#import "YXAccountMannger.h"

@implementation YXAccountMannger

/**
 *    @brief    设置用户信息
 */
+(void)setUserInfo:(YXUserModel*)userInfo{

    m_UserDefaultSetObjectForKey([NSKeyedArchiver archivedDataWithRootObject:userInfo], AccountUserInfoKey);

    [self setUserLoginStatus:YES];
    
    //保存的用户信息没有Token 清空用户信息
    if ([NSString ol_isNullOrNilWithObject:userInfo.access_token]) {
        
        [self removeUserInfo];
        
    }

}

/**
 *    @brief    设置用户登录状态
 *
 *    @param     status     登录状态
 */
+(void)setUserLoginStatus:(BOOL)status{

    BOOL isLogin = [self isLogin];
    
    if (status != isLogin) {//变更登录状态
        
        NSNumber *loginStatus = [NSNumber numberWithBool:status];
        m_UserDefaultSetObjectForKey(loginStatus, AccountUserIsLoginKey);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AccountUserLoginStatusDidChangeDidChangeNotification object:loginStatus];
        
        NSLog(@"\n\n\n 用户登录状态变更 \n *** %@ *** \n\n\n",status?@"已登录":@"未登录");
        
    }
    
}

/**
 *    @brief    获取用户信息
 */
+(YXUserModel*)getUserInfo{

    return [NSKeyedUnarchiver unarchiveObjectWithData:m_UserDefaultObjectForKey(AccountUserInfoKey)];

}

/**
 *    @brief    更新用户信息
 */
+(void)updateUserInfoValue:(id)value forKey:(NSString*)key notice:(BOOL)notice{

//    RTProperty *property = [YXUserModel rt_propertyForName:key];
//
//    if (property) {//键真实存在
//
//        YXUserModel *userInfo = [self getUserInfo];
//
//        id oldValue = [userInfo valueForKey:key];
//
//        //目前只处理NSNumber/NSString两种类型
//
//        if ([property.typeEncoding isEqualToString:@"d"]) {
//            NSAssert([value isKindOfClass:NSNumber.class], @" %s 目标为double类型，而传入的Value不是NSNumber类型",__func__);
//        }
//
//        [userInfo setValue:value forKey:key];
//
//        m_UserDefaultSetObjectForKey([NSKeyedArchiver archivedDataWithRootObject:userInfo], AccountUserInfoKey);
//
//        if (notice) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:AccountUserInfoDidChangeNotification object:userInfo];
//        }
//
//        NSLog(@"\n\n\n 用户信息Model变更 \n *** key *** \n %@ \n *** value *** \n %@\n *** oldValue *** \n %@\n\n\n",key,value,oldValue);
//
//    }

}

/**
 *    @brief    清除用户信息
 */
+(void)removeUserInfo{

    m_UserDefaultRemoveObjectForKey(AccountUserInfoKey);

    [self setUserLoginStatus:NO];

}

/**
 *    @brief    用户是否登录
 */
+(BOOL)isLogin{

    NSString *userID = m_UserDefaultObjectForKey(Account_User_ID);
    return !isEmptyString(userID) ;

}

@end
