//
//  NSObject+Common.m
//  YaoXiu
//
//  Created by MAC on 2020/3/28.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "NSObject+Common.h"


@implementation NSObject (Common)

+(UIWindow *)getCurrentWindow{
    
  UIWindow* window = nil;
   
          if (@available(iOS 13.0, *))
          {
              for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
              {
                  if (windowScene.activationState == UISceneActivationStateForegroundActive)
                  {
                      window = windowScene.windows.firstObject;
   
                      break;
                  }
              }
          }else{
              window = [UIApplication sharedApplication].keyWindow;
          }
    return window;
}
+ (UIViewController *)getCurrentVC {
    
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

@end
