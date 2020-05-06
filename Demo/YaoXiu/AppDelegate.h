//
//  AppDelegate.h
//  XiaoShiPin
//
//  Created by cui on 2019/11/11.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,JMessageDelegate>
{
    UIAlertView *myAlertView;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) JCHATTabBarViewController *tabBarCtl;

@property (assign, nonatomic)BOOL isDBMigrating;

- (void)setupMainTabBar;
@end

