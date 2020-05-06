//
//  BaseNavigationController.m
//  MCTabBarDemo
//
//  Created by chh on 2017/12/18.
//  Copyright © 2017年 Mr.C. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor]; //设置导航栏左侧与右侧按钮颜色
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]]; //设置导航栏标题文字属性
    self.navigationBar.barTintColor = mainColor; //设置导航栏背景色
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -500) forBarMetrics:UIBarMetricsDefault];
    
    UIOffset offset;
    offset.horizontal = -500;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
}

////重写这个方法，在跳转后自动隐藏tabbar
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if ([self.viewControllers count] > 0){
//        viewController.hidesBottomBarWhenPushed = YES;
////        [AppDelegate delegate].isAddBtnShow = NO;
//    }
//    //一定要写在最后，要不然无效
//    [super pushViewController:viewController animated:animated];
//
//
//}

//重写这个方法，在跳转后自动隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        //可以在这里定义返回按钮等
        /*
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        viewController.navigationItem.leftBarButtonItem = backItem;
         */
    }
    //一定要写在最后，要不然无效
    [super pushViewController:viewController animated:animated];
    //处理了push后隐藏底部UITabBar的情况，并解决了iPhonX上push时UITabBar上移的问题。
    CGRect rect = self.tabBarController.tabBar.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height - rect.size.height;
    self.tabBarController.tabBar.frame = rect;
}


@end
