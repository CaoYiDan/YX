//
//  ViewController.m
//  VTMagicView

//  Created by tianzhuo on 14-11-11.

//  Copyright (c) 2014年 tianzhuo. All rights reserved.

#import "YXHomeVC.h"
#import "YXFollowVC.h"
#import "YXCommonCityVC.h"
#import "YXLocationListVC.h"
#import "TCVideoListViewController.h"
#import "GKDYPlayerViewController.h"
#import "TCVideoPublishController.h"
@interface YXHomeVC()

@property (nonatomic, strong)  NSArray *menuList;

@property (nonatomic, assign)  BOOL autoSwitch;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation YXHomeVC
{
    NSInteger *selectedIndex;
    NSArray *chanlesArr;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     //测试Access_Token
  m_UserDefaultSetObjectForKey(@"941eedc64f1511a967c38fa728530dae", Account_Access_Token)
    //用户头像
  m_UserDefaultSetObjectForKey(@"https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3173584241,3533290860&fm=26&gp=0.jpg", Account_HeaderImgUrl)
    //ID
    m_UserDefaultSetObjectForKey(@"", Account_User_ID)
    m_UserDefaultSetObjectForKey(@"lisen", Account_NickName);
    
    
    
    [self configMargic];
    
    [self setLeftAndRightItem];
    
    [self addNotification];
    
    //首次展示达人界面
    [self.magicView switchToPage:2 animated:NO];
   
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
//     m_CheckUserLogin;
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear: animated];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification
- (void)addNotification {
    
    [self removeNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(statusBarOrientationChange:)
  name:UIApplicationDidChangeStatusBarOrientationNotification
    object:nil];
}

- (void)removeNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
//
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
  
    return self.menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGB(200, 197, 195) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGB(254, 254, 254) forState:UIControlStateSelected];
        menuItem.titleLabel.font = m_FontPF_Medium_WithSize(17);
        
    }
  
    [menuItem setTitle:_menuList[itemIndex] forState:UIControlStateNormal];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    
    NSString *gridId = @"identifer";
    gridId =  [NSString stringWithFormat:@"%ld---identifier",pageIndex];
    
    if (pageIndex==0) {
        
        YXFollowVC *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
         if (!viewController){
             viewController = [[YXFollowVC alloc] init];
         }
         return viewController;
    }else if (pageIndex==1){
        
        YXCommonCityVC *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
         if (!viewController){
             viewController = [[YXCommonCityVC alloc] init];
         }
         return viewController;
        
    }else if (pageIndex==2){
        
//        return [[UIViewController alloc]init];
        GKDYPlayerViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
         if (!viewController){
             viewController = [[GKDYPlayerViewController alloc] init];
         }
         return viewController;
        
    }else{
        
        return [[UIViewController alloc]init];
    }
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    //    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

#pragma mark - actions

- (void)subscribeAction {
    
    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
}

#pragma mark - functional methods
- (NSArray *)menuList{
    
    if (!_menuList) {
        _menuList = @[@"关注",@"同城",@"达人"];
    }
    return _menuList;
}

- (void)setLeftAndRightItem{
    
    UIView *baseLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30+KMargin, 30)];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(KMargin, 0, 30, 30)];
    [leftButton addTarget:self action:@selector(p_scanClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"scan"] forState:0];
    [baseLeftView addSubview:leftButton];
    self.magicView.leftNavigatoinItem = baseLeftView;
    
    UIView *baseRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30+KMargin, 30)];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(p_searchClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"search"] forState:0];
    [baseRightView addSubview:rightButton];
    self.magicView.rightNavigatoinItem = baseRightView;
}

#pragma  mark 配置magic

-(void)configMargic{
    
     self.magicView.navigationColor = KClearColor;
     self.magicView.layoutStyle = VTLayoutStyleCenter;
     self.magicView.switchStyle = VTSwitchStyleDefault;
     self.magicView.headerHeight = GK_STATUSBAR_HEIGHT;
     self.magicView.navigationHeight = 44;
     self.magicView.needPreloading = NO;
     self.magicView.headerHidden = NO;
     self.magicView.sliderExtension = -8;
     self.magicView.sliderHeight = 4;
     self.magicView.sliderOffset = -3;
     self.magicView.dataSource = self;
     self.magicView.delegate = self;
     self.magicView.itemScale = 1.1;
     self.magicView.itemSpacing = 30.f;
     self.magicView.sliderColor = KMainYellowColor;
     self.magicView.sliderCornerRadius = 2;
     self.magicView.backgroundColor = RGBA(40, 40, 40, 1);
     self.magicView.isFullShow = YES;
     self.magicView.separatorColor = UIColor.clearColor;
     
     [self.magicView  reloadData];
     
}

@end
