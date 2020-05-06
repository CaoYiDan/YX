//
//  DataRequest.h
//  Dream100
//
//  Created by 杨壮 on 2017/7/11.
//  Copyright © 2017年 YangZhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import <AVFoundation/AVFoundation.h>

@interface DataRequest : NSObject


+(id)Manager;

- (void)SendUrl:(NSString *)url SendData:(NSMutableDictionary *)dic Completion:(void(^)(id responseObject))completion;

- (void)realNameSendUrl:(NSString *)url SendData:(NSMutableDictionary *)dic Completion:(void (^)(id))completion;

- (void)SendUrl:(NSString *)url Completion:(void (^)(id))completion;

- (void)uploadPhoto:(NSString *)url Image:(UIImage *)image radio:(CGFloat)ratio Completion:(void(^)(id responseObject))completion;

- (void)appPostForUploadVideo:(NSString *)url paramers:(NSDictionary *)paramers withVideoURL:(NSURL *)VideoURL progress:(void (^)(NSProgress * progress))VideoUploadProgress handler:(void(^)(BOOL successful, NSDictionary *response))handler;

- (void)postBossDemoWithUrl:(NSString*)url

                     param:(NSString*)param

                   success:(void(^)(NSDictionary *dict))success

                      fail:(void (^)(NSError *error))fail;
@end
