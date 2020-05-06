
#import "AppDelegate.h"
#import <UGCKit/UGCKit.h>
#import "SDKHeader.h"
#import "GKDYHomeViewController.h"
#import "GKDYShootViewController.h"
#import "GKDYNavigationController.h"

#import "SLLocationHelp.h"
#import <JMessage/JMessage.h>
#import "JCHATConversationListViewController.h"

//测试
#import "TCLoginViewController.h"
#import "TCLoginModel.h"
#import "CommentsPopView.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {




  //腾讯云短视频配置
  [TXUGCBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/9f33bff33362109434e376d4f7927b01/TXUgcSDK.licence" key:@"4c587318ff51c7d0ce3672479b80fd81"];

    [GKConfigure setupCustomConfigure:^(GKNavigationBarConfigure *configure) {
        configure.backStyle             = GKNavigationBarBackStyleWhite;
        configure.titleFont             = m_FontPF_Medium_WithSize(17);
        configure.titleColor            = RGB(254, 254, 254);
        configure.gk_navItemLeftSpace   = 12.0f;
        configure.gk_navItemRightSpace  = 12.0f;
        configure.statusBarStyle        = UIStatusBarStyleLightContent;
        configure.gk_translationX       = 10.0f;
        configure.gk_translationY       = 15.0f;
        configure.gk_scaleX             = 0.90f;
        configure.gk_scaleY             = 0.95f;
//        configure.backgroundColor = KMainYellowColor;
    }];

    //极光IM
    [self JGIMMessageApplication:application didFinishLaunchingWithOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    GKDYNavigationController *nav = [GKDYNavigationController rootVC:[GKDYShootViewController new] translationScale:YES];

//    GKDYNavigationController *nav = [GKDYNavigationController rootVC:[GKDYHomeViewController new] translationScale:NO];
    nav.gk_openScrollLeftPush = YES; // 开启左滑push功能
    nav.navigationBar.hidden = YES;

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    [self testLogin];


    return YES;
}

//极光配置
-(void)JGIMMessageApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    // Required - 启动 JMessage SDK
       [JMessage setupJMessage:launchOptions appKey:JMESSAGE_APPKEY channel:nil apsForProduction:NO category:nil];
       // Required - 注册 APNs 通知
       if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
           //可以添加自定义categories
           [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                             UIUserNotificationTypeSound |
                                                             UIUserNotificationTypeAlert)
                                                 categories:nil];
       } else {
           //categories 必须为nil
           [JMessage registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                             UIRemoteNotificationTypeSound |
                                                             UIRemoteNotificationTypeAlert)
                                                 categories:nil];
       }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册token
    [JMessage registerDeviceToken:deviceToken];
}
//暂时先这样登陆
-(void)testLogin{

//    TCLoginViewController *vc = [[TCLoginViewController alloc]init];
//    [vc viewDidLoad];

//    [[TCLoginModel sharedInstance] login:@"lisen" hashPwd:@"lisen093" succ:^(NSString* userName, NSString* md5pwd ,NSString *token,NSString *refreshToken,long expires) {
//
//        NSLog(@"fsd");
//            } fail:^(NSString *userName, int errCode, NSString *errMsg) {
//                NSLog(@"%@",errMsg);
//            }];
//    [self showLoginUI];
}

- (void)showLoginUI {

    TCLoginViewController *loginViewController = [[TCLoginViewController alloc] init];
    [loginViewController setupUI];

}

@end
