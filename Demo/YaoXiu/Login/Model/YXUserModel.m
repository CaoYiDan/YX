//
//  YXUserModel.m
//  YaoXiu
//
//  Created by MAC on 2020/3/31.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "YXUserModel.h"
#import "NSObject+MJCoding.h"
@implementation YXUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id",
             };
}

MJCodingImplementation
@end
