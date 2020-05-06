//
//  ViewController.m
//  VTMagicView

//  Created by tianzhuo on 14-11-11.

//  Copyright (c) 2014年 tianzhuo. All rights reserved.

#import "YXFansAndFllowSVC.h"

#import "YXFansVC.h"
#import "YXFollowSListVC.h"

@interface YXFansAndFllowSVC()

@property (nonatomic, strong)  NSArray *menuList;

@property (nonatomic, assign)  BOOL autoSwitch;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation YXFansAndFllowSVC
{
    NSInteger *selectedIndex;
    NSArray *chanlesArr;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.title = @"lisendddd";
    
    [self configMargic];
    [self setTopNavigationView];
    [self addNotification];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear: animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
        menuItem.titleLabel.font = m_FontPF_Medium_WithSize(14);
        
    }
  
    [menuItem setTitle:_menuList[itemIndex] forState:UIControlStateNormal];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    
    NSString *gridId = @"fansAndFollowsIdentifer";
    gridId =  [NSString stringWithFormat:@"%ld---identifier",pageIndex];
    
    if (pageIndex==0) {
        
        YXFollowSListVC *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
         if (!viewController){
             viewController = [[YXFollowSListVC alloc] init];
         }
         return viewController;
    }else if (pageIndex==1){
        
        YXFansVC *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
                if (!viewController){
                    viewController = [[YXFansVC alloc] init];
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
        _menuList = @[@"关注",@"粉丝"];
    }
    return _menuList;
}


#pragma  mark 配置magic

-(void)configMargic{
 
  
     self.magicView.navigationColor = KClearColor;
     self.magicView.layoutStyle = VTLayoutStyleDivide;
     self.magicView.switchStyle = VTSwitchStyleDefault;
     self.magicView.headerHeight = 0;
     self.magicView.navigationHeight = 44;
     self.magicView.needPreloading = NO;
     self.magicView.headerHidden = NO;
     self.magicView.sliderExtension = 0;
     self.magicView.sliderHeight = 1.5;
     self.magicView.sliderOffset = -3;
     self.magicView.dataSource = self;
     self.magicView.delegate = self;
     self.magicView.itemScale = 1.1;
     self.magicView.itemSpacing = 30.f;
     self.magicView.sliderColor = KMainYellowColor;
     self.magicView.sliderCornerRadius = 2;
     self.magicView.backgroundColor = RGBA(0, 0, 0, 1);
   
     self.magicView.separatorColor = UIColor.clearColor;
     
     [self.magicView  reloadData];
     
}

#pragma  mark  设置navigationview

-(void)setTopNavigationView{
  
    
    ls_view(base, m_Color_gray(40), self.view, {
        make.left.offset(0);
        makeTopOffSet(self.view, 0);
        make.width.offset(44);
        make.height.offset(44);
    })
    ls_button(back, @"", m_FontPF_Medium_WithSize(12), ColorBlack, @"backIcon", ColorClear, 0, baseView, {
           make.left.offset(0);
           makeTopOffSet(baseView, 0);
           make.width.offset(44);
           make.height.offset(44);
       }, {
           [self dismissViewControllerAnimated:YES completion:nil];
       });
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:baseView];
    
    return;
    ls_label(title, @"lisen", m_Color_RGB(255, 255, 255), m_FontPF_Regular_WithSize(17),ColorClear, NSTextAlignmentCenter, baseView, {
        make.left.offset(0);
        makeTopOffSet(baseView, SafeAreaStatusHeight);
        make.width.offset(ScreenWidth);
        make.height.offset(44);
    })
    
//    ls_button(back, @"", m_FontPF_Medium_WithSize(12), ColorBlack, @"backIcon", ColorClear, 0, baseView, {
//        make.left.offset(KMargin);
//        makeTopOffSet(baseView, SafeAreaStatusHeight);
//        make.width.offset(44);
//        make.height.offset(44);
//    }, {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    });
    
}

@end
