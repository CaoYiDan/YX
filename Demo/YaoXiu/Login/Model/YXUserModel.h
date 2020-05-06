//
//  YXUserModel.h
//  YaoXiu
//
//  Created by MAC on 2020/3/31.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXUserModel : NSObject
/** 昵称*/
@property (nonatomic, copy) NSString *user_name;

/** 用户ID*/
@property (nonatomic, copy) NSString *ID;

/** 安全令牌    用于需要令牌的其他接口,请保存它以便调用其它接口时使用*/
@property (nonatomic, copy) NSString *access_token;

/** 省*/
@property (nonatomic, copy) NSString *user_address_province;
/** 简介*/
@property (nonatomic, copy) NSString *user_introduction;
/** 吆秀号*/
@property (nonatomic, copy) NSString *user_yx_no;
/** 地区*/
@property (nonatomic, copy) NSString *user_address_area;
/** 状态*/
@property (nonatomic, assign) int status;
/** 喜欢视频数*/
@property (nonatomic, copy) NSString *like_list_count;
/** 市*/
@property (nonatomic, copy) NSString *user_address_city;
/** 性别*/
@property (nonatomic, assign) int user_sex;
/** 生日*/
@property (nonatomic, copy) NSString *user_birthday;
/** 头像*/
@property (nonatomic, copy) NSString *user_head_img;
/** */
@property (nonatomic, assign) int status_followed;
/** 是否关注当前目标用户*/
@property (nonatomic, copy) NSString *count_belike;
/** 数据ID*/
//@property (nonatomic, assign)  ID;
/** 粉丝数*/
@property (nonatomic, copy) NSString *count_fans;
/** 喜欢的视频数*/
@property (nonatomic, copy) NSString *count_like;
/** 发表视频数*/
@property (nonatomic, copy) NSString *video_list_count;
/** 国家*/
@property (nonatomic, copy) NSString *user_address_county;
/** 昵称*/
@property (nonatomic, copy) NSString *user_nick_name;
/** 是否为当前用户自己*/
@property (nonatomic, assign) BOOL is_self;

@end

NS_ASSUME_NONNULL_END
