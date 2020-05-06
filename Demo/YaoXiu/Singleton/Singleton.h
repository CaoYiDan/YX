//
//  Singleton.h
//  Pos
//
//  Created by mac on 2018/9/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface Singleton : NSObject

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, assign) BOOL isWeiXin;

+(Singleton *)shardeManger;

- (void)gotoLogin;

- (NSString *)getTimeFromTimestamp:(double)time;

//时间戳转换
- (NSString *)getHomeTimeFromTimestamp:(double)time;

- (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

- (NSString *)stringWithTimeStamp:(NSNumber *)timeStamp;

- (BOOL)isLogin;
//获取当前控制器
- (UIViewController *)getCurrentVC;
//手机号正则
- (BOOL)checkTelNumber:(NSString *)telNumber;

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;
//MD5加密
- (NSString *)MD5ForLower32Bate:(NSString *)str;
//数组转json串
- (NSString *)arrayToJSONString:(NSMutableArray *)array;
//字典转json
-(NSString *)convertToJsonData:(NSMutableDictionary *)dict;
//获取当前时间
- (NSString *)getCurrentTimes;
//图片url转UIImage
- (UIImage *)getImageFromURL:(NSString *)fileURL;
//身份证正则
- (BOOL)checkUserID:(NSString *)userID;
@end
