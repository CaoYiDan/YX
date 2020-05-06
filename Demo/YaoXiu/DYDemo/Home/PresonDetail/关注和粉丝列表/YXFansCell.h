//
//  YXFansCell.h
//  YaoXiu
//
//  Created by MAC on 2020/4/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface YXFansCell : UITableViewCell

/** model */
@property (nonatomic, strong) YXUserModel *model;

@end

NS_ASSUME_NONNULL_END
