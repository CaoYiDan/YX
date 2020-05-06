//
//  GKDYMainViewController.m
//  GKDYVideo
//
//  Created by gaokun on 2018/12/12.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYMainViewController.h"
#import "GKDYNavigationController.h"
#import "GKDYAttentViewController.h"
#import "GKDYMessageViewController.h"
#import "MyViewController.h"
#import "UIImage+GKCategory.h"
#import "GKDYTabBar.h"
#import "YXHomeVC.h"
#import "TCLoginParam.h"
#import "UGCKitWrapper.h"
#import "GKDYMineViewController.h"
@interface GKDYMainViewController ()<UITabBarControllerDelegate, GKDYPlayerViewControllerDelegate, GKViewControllerPopDelegate,GKDYTabBarDelegate>

@property (nonatomic, strong) GKDYTabBar    *dyTabBar;
@property (strong, nonatomic) UGCKitWrapper *ugcWrapper;  // UGC 业务逻辑
@end

@implementation GKDYMainViewController
{
    UGCKitTheme *_theme;
    UIView       *_botttomView;
    UIView       *_myBotttomView;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.delegate = self;
    
    // 替换系统tabbar
    self.dyTabBar = [GKDYTabBar new];
    self.dyTabBar.myDelegate = self;
    [self setValue:self.dyTabBar forKey:@"tabBar"];
    
    _theme = [[UGCKitTheme alloc] init];
    _theme.nextIcon = [UIImage imageNamed:@"ready"];
    
    _theme.recordButtonPauseInnerIcon = [UIImage imageNamed:@"录音按钮"];
    _theme.recordButtonTapModeIcon = [UIImage imageNamed:@"录音按钮"];
    //warning闪光灯的控件上 覆盖了一个本地上传的按钮，所以将闪光灯的图标设置为空，
    _theme.recordTorchOnIcon = [UIImage imageNamed:@""];
    _theme.recordTorchOnHighlightedIcon = [UIImage imageNamed:@""];
    _theme.recordTorchOffIcon = [UIImage imageNamed:@""];
    _theme.recordTorchDisabledIcon  = [UIImage imageNamed:@""];
    _ugcWrapper = [[UGCKitWrapper alloc] initWithViewController:self theme:_theme];
     
//    self.playerVC = [GKDYPlayerViewController new];
//    self.playerVC.delegate = self;
    self.homeVC = [[YXHomeVC alloc]init];
    
    [self addChildVC:self.homeVC title:@"首页"];
    [self addChildVC:[GKDYAttentViewController new] title:@"关注"];
    [self addChildVC:[GKDYMessageViewController new] title:@"消息"];
//    [self addChildVC:[GKDYMineViewController new] title:@"我"];
    [self addChildVC:[MyViewController new] title:@"我"];
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onVideoSelectClicked) name:@"SelectedVideFromLocationClicked" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)onVideoBtnClicked
{
    UGCKitRecordConfig *config = [[UGCKitRecordConfig alloc] init];
    UGCKitWatermark *watermark = [[UGCKitWatermark alloc] init];
    watermark.image = [UIImage imageNamed:@"watermark"];
    watermark.frame = CGRectMake(0.01, 0.01, 0.1, 0.3);
    config.watermark = watermark;
    config.minDuration = 5;
    [self.ugcWrapper showRecordViewControllerWithConfig:config];
    _botttomView.hidden = YES;
}
-(void)onVideoSelectClicked
{
    UGCKitMediaPickerConfig *config = [[UGCKitMediaPickerConfig alloc] init];
    config.mediaType = UGCKitMediaTypeVideo;
    config.maxItemCount = NSIntegerMax;
    UGCKitMediaPickerViewController *imagePickerController = [[UGCKitMediaPickerViewController alloc] initWithConfig:config theme:_theme];
    GKDYNavigationController *nav = [[GKDYNavigationController alloc] initWithRootViewController:imagePickerController];
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    __weak __typeof(self) wself = self;
    __weak UINavigationController *navigationController = nav;
    imagePickerController.completion = ^(UGCKitResult *result) {
        if (!result.cancelled && result.code == 0) {
            [wself _showVideoCutView:result inNavigationController:navigationController];
        } else {
            NSLog(@"isCancelled: %c, failed: %@", result.cancelled ? 'y' : 'n', result.info[NSLocalizedDescriptionKey]);
            [wself dismissViewControllerAnimated:YES completion:^{
                if (!result.cancelled) {
                    UIAlertController *alert =
                    [UIAlertController alertControllerWithTitle:result.info[NSLocalizedDescriptionKey]
                                                        message:nil
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
    };
    [[NSObject getCurrentVC] presentViewController:nav animated:YES completion:NULL];
   
}

- (void)_showVideoCutView:(UGCKitResult *)result inNavigationController:(UINavigationController *)nav {
    UGCKitCutViewController *vc = [[UGCKitCutViewController alloc] initWithMedia:result.media theme:_theme];
    __weak __typeof(self) wself = self;
    __weak UINavigationController *weakNavigation = nav;
    vc.completion = ^(UGCKitResult *result, int rotation) {
        if ([result isCancelled]) {
            [wself dismissViewControllerAnimated:YES completion:nil];
        } else {
            [wself.ugcWrapper showEditViewController:result rotation:rotation inNavigationController:weakNavigation backMode:TCBackModePop];
        }
    };
    [nav pushViewController:vc animated:YES];
}
- (void)addChildVC:(UIViewController *)childVC title:(NSString *)title {
    
    childVC.tabBarItem.title = title;
    childVC.tabBarItem.image = [[UIImage gk_imageWithColor:[UIColor clearColor] size:CGSizeMake(36, 3)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage gk_imageWithColor:[UIColor whiteColor] size:CGSizeMake(36, 3)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -14);
    childVC.tabBarItem.imageInsets = UIEdgeInsetsMake(28, 0, -28, 0);
    
    [childVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.8]} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];

    GKDYNavigationController *nav = [GKDYNavigationController rootVC:childVC translationScale:NO];
    nav.gk_openScrollLeftPush = NO;
    [self addChildViewController:nav];
}

#pragma mark - GKDYPlayerViewControllerDelegate

- (void)playerVC:(GKDYPlayerViewController *)playerVC controlView:(nonnull GKDYVideoControlView *)controlView isCritical:(BOOL)isCritical {
    
    GKSliderView *sliderView = controlView.sliderView;
    
    if (isCritical) { // 到达临界点，隐藏分割线
        sliderView.maximumTrackTintColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
        [self.dyTabBar hideLine];
    }else {
        sliderView.maximumTrackTintColor = [UIColor clearColor];
        [self.dyTabBar showLine];
    }
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (!AccountMannger_isLogin) {
        [LoginViewController gw_showLoginVCWithCompletion:nil];;
        return NO;
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (tabBarController.selectedIndex == 2 || tabBarController.selectedIndex == 3) {
        self.gk_popDelegate = self;
    }else {
        self.gk_popDelegate = nil;
    }
}

#pragma mark - 点击发布事件
- (void)tabBarMiddleClickDelegate{
    
    [self onVideoBtnClicked];
    
//    _botttomView.hidden = !_botttomView.isHidden;
//
//    return;
//
//    if(![self checkLoginStatus]) return;
//
//       UGCKitRecordConfig *config = [[UGCKitRecordConfig alloc] init];
//       UGCKitWatermark *watermark = [[UGCKitWatermark alloc] init];
//       watermark.image = [UIImage imageNamed:@"watermark"];
//       watermark.frame = CGRectMake(0.01, 0.01, 0.1, 0.3);
//       config.watermark = watermark;
//       [self.ugcWrapper showRecordViewControllerWithConfig:config];
}

-(BOOL)checkLoginStatus{
    
    if([TCLoginParam shareInstance].isExpired){
        // TODO: logout
//        if (self.loginHandler) {
//            self.loginHandler(self);
//        }
        return NO;
    }
    return YES;
}

- (void)initBottomView
{
    
   ls_view(bottom_, RGBA(57, 57, 57, 0.8), self.view, {
       make.left.offset(0);
       makeBottomOffSet(self.view, -SafeAreaBottomHeight-60+NAVBAR_HEIGHT-2);
       make.width.offset(ScreenWidth);
       make.height.offset(60+NAVBAR_HEIGHT+SafeAreaBottomHeight);
   })
    
    ls_cornerRadius(bottom_View, 8);
    _botttomView = bottom_View;
   
    UIButton *(^createButton)(NSString *title, NSString *imageName, SEL action) = ^(NSString *title, NSString *imageName, SEL action) {
        UGCKitVerticalButton * button = [[UGCKitVerticalButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
       
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
        [button sizeToFit];
        return button;
    };

    UIButton * btnCamera = createButton(@"TCMainTabView.Record", @"tab_camera", @selector(onVideoBtnClicked));
   
    UIButton * btnVideo = createButton(@"TCMainTabView.EditVideo", @"tab_video", @selector(onVideoSelectClicked));
   
    _botttomView.hidden = YES;
    [_botttomView addSubview:btnCamera];
    [_botttomView addSubview:btnVideo];
    CGFloat btnW = (ScreenWidth-KMargin*2)/2;
    [btnCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMargin);
        make.centerY.equalTo(_botttomView).offset(-20);
        make.width.offset(btnW);
        make.height.offset(56);
    }];
    [btnVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(btnW+KMargin);
        make.centerY.equalTo(_botttomView).offset(-20);
        make.width.offset(btnW);
        make.height.offset(56);
    }];
    
    ls_button(close, @"", m_FontPF_Medium_WithSize(12), KMainYellowColor, @"icon_closetopic", KMainYellowColor, 17.5, _botttomView, {
        make.centerX.offset(0);
        makeBottomOffSet(_botttomView, -10);
        make.width.offset(35);
        make.height.offset(35);
    },{
        _botttomView.hidden = YES;
    })
}

@end
