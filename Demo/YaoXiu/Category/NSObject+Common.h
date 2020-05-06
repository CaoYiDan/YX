//
//  NSObject+Common.h
//  YaoXiu
//
//  Created by MAC on 2020/3/28.
//  Copyright © 2020 Tencent. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Common)

+(UIWindow *)getCurrentWindow;

+ (UIViewController *)getCurrentVC;

@end

NS_ASSUME_NONNULL_END
