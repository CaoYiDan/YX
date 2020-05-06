//
//  YXHomeVC.h
//  YaoXiu
//
//  Created by MAC on 2020/3/28.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <VTMagic/VTMagic.h>

@class  YXBaseHomeVC;

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeVC : VTMagicController

/**  */
@property (nonatomic, strong) YXBaseHomeVC *currentListVC;

@end

NS_ASSUME_NONNULL_END
