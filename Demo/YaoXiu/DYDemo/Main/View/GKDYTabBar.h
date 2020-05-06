//
//  GKDYTabBar.h
//  GKDYVideo
//
//  Created by gaokun on 2019/5/8.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GKDYTabBarDelegate <NSObject>
//设置点击中间按钮的代理
-(void)tabBarMiddleClickDelegate;

@end

@interface GKDYTabBar : UITabBar

@property(nonatomic,weak)id<GKDYTabBarDelegate> myDelegate;

- (void)showLine;
- (void)hideLine;

@end

NS_ASSUME_NONNULL_END
