//
//  Header.h
//  GUOWER
//
//  Created by ourslook on 2018/6/25.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#ifndef Header_h
#define Header_h

/** 用户信息键 */
static NSString *const AccountUserInfoKey = @"AccountUserInfoKey";
/** 用户是否登录键 */
static NSString *const AccountUserIsLoginKey = @"AccountUserIsLoginKey";
/** 用户信息变更通知 */
static NSString *const AccountUserInfoDidChangeNotification = @"AccountUserInfoDidChangeNotification";
/** 用户登录状态变更通知 */
static NSString *const AccountUserLoginStatusDidChangeDidChangeNotification = @"AccountUserLoginStatusDidChangeDidChangeNotification";
/** 上下滑动列表需要加载更多数据 */
static NSString *const VideoNeedLoadMoreNotification = @"VideoNeedLoadMoreNotification";
/** 滑动列表加载完成了更多数据 */
static NSString *const VideoHaveLoadMoreNotification = @"VideoHaveLoadMoreNotification";
/** 用户ID */
static NSString *const Account_User_ID = @"Account_User_ID";
/** 用户access_token */
static NSString *const Account_Access_Token = @"Account_Access_Token";
/** 用户头像 */
static NSString *const Account_HeaderImgUrl = @"Account_HeaderImgUrl";
/** 用户昵称 */
static NSString *const Account_NickName = @"Account_NickName";
/**longitude*/
static NSString *const Account_Longitude = @"Account_longitude";
/** latitude */
static NSString *const Account_Latitude = @"Account_latitude";

#endif /* Header_h */
