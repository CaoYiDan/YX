//
//  YXLoginManager.h
//  YaoXiu
//
//  Created by MAC on 2020/4/1.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXLoginManager : NSObject

-(void)logionWithAccount:(NSString *)account password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
