//
//  GKDYNavigationController.m
//  GKDYVideo
//
//  Created by QuintGao on 2019/4/21.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDYNavigationController.h"

@interface GKDYNavigationController ()

@end

@implementation GKDYNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIColor imageWithColor:m_Color_gray(40)] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.tintColor = [UIColor whiteColor];
    //调导航栏标题的的颜色和大小
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:m_FontPF_Regular_WithSize(17),NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        UIViewController *root = self.childViewControllers[0];
        if (viewController != root) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        
        if (self.childViewControllers.count) {
            viewController.hidesBottomBarWhenPushed = YES;
            
            UIButton *button = [[UIButton alloc] init];
            [button setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, 44, 44);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleLabel.font = [UIFont systemFontOfSize:1];
            
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            
        }
    }
    [super pushViewController:viewController animated:animated];
}

-(void)back{
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        return ((UITabBarController *)topVC).selectedViewController;
    }
    return topVC;
}

@end
