//
//  GKDYListViewController.h
//  GKDYVideo
//
//  Created by gaokun on 2018/12/14.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYBaseViewController.h"
#import <GKPageScrollView/GKPageScrollView.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCommonCityVC : GKDYBaseViewController<GKPageListViewDelegate>

/**target_user_id */
@property (nonatomic, copy) NSString *target_user_id;

@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic, assign) NSInteger         selectedIndex;

@property (nonatomic, copy) void(^itemClickBlock)(NSArray *videos, NSInteger index);

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
