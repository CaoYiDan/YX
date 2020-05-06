//
//  YXLocationListVC.h
//  YaoXiu
//
//  Created by MAC on 2020/4/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "BaseTableViewController.h"
@class ZHPlaceInfoModel;

typedef void (^selectedResult)(ZHPlaceInfoModel *model);

NS_ASSUME_NONNULL_BEGIN

@interface YXLocationListVC : BaseTableViewController

/** 回传数据*/
@property (nonatomic, copy)selectedResult block;

@end

NS_ASSUME_NONNULL_END
