//
//  GKDYVideoViewModel.h
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKDYVideoModel.h"
//请求类型
typedef NS_ENUM(NSInteger,RequestType){
   
    RequestTypeWishMan,//达人
    RequestTypeSomeOne,//某一个人的作品
    RequestTypeCommonCity,//同城
};
NS_ASSUME_NONNULL_BEGIN

@interface GKDYVideoViewModel : NSObject

@property (nonatomic, assign) BOOL  has_more;

/** 请求类型*/
@property (nonatomic, assign) RequestType requestType;

/**target_user_id */
@property (nonatomic, copy) NSString *target_user_id;

- (void)refreshNewListWithSuccess:(void(^)(NSArray *list))success
                            failure:(void(^)(NSError *error))failure;

- (void)refreshMoreListWithSuccess:(void(^)(NSArray *list))success
                            failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
