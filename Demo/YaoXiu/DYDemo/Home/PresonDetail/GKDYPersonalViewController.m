//
//  GKDYPersonalViewController.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/24.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYPersonalViewController.h"
#import "GKNetworking.h"
#import <JMessage/JMSGConversation.h>
#import "JCHATConversationViewController.h"
#import "GKDYVideoViewModel.h"
#import "GKDYPersonalModel.h"
#import <GKPageScrollView/GKPageScrollView.h>
#import <JXCategoryView/JXCategoryView.h>
#import "UserInfoHeader.h"
#import "GKDYVideoViewController.h"
#import "GKDYListCollectionViewCell.h"
#import "GKDYScaleVideoView.h"
#import "YXUserModel.h"
#import "GKSlidePopupView.h"
#import "User.h"
@interface GKDYPersonalViewController ()<GKPageScrollViewDelegate, GKPageTableViewGestureDelegate, JXCategoryViewDelegate, UIScrollViewDelegate, GKDYVideoViewDelegate,UserInfoDelegate>

@property (nonatomic, strong) GKPageScrollView      *pageScrollView;

@property (nonatomic, strong) UserInfoHeader        *headerView;

/** model */
@property (nonatomic, strong) YXUserModel *userModel;

@property (nonatomic, strong) UIView                *pageView;
@property (nonatomic, strong) JXCategoryTitleView   *categoryView;
@property (nonatomic, strong) UIScrollView          *scrollView;

@property (nonatomic, strong) NSArray               *titles;

@property (nonatomic, strong) UILabel               *titleView;

@property (nonatomic, weak) GKDYScaleVideoView      *scaleView;

@end

@implementation GKDYPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = GKColorRGB(0, 0, 0);
    
    self.gk_navTitleView = self.titleView;
    
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    
    self.gk_navLineHidden = YES;
    
    [self.view addSubview:self.pageScrollView];
    self.pageScrollView.delegate = self;
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    self.headerView.model = self.model;
    
    [self.pageScrollView reloadData];
    
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.scaleView) {
        [self.view bringSubviewToFront:self.scaleView];
    }
    
//    self.gk_navigationBar.hidden = YES;
    
//    self.gk_navigationBar.hidden = NO;
//    self.gk_navigationBar.hidden = YES;
//       self.gk_navBackgroundColor = [UIColor clearColor];
//     self.gk_navBarAlpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 默认点击第一个
    [self categoryView:self.categoryView didSelectedItemAtIndex:0];
    
    [self.scaleView.videoView resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.scaleView.videoView pause];

}

- (void)showVideoVCWithVideos:(NSArray *)videos index:(NSInteger)index {
    GKDYScaleVideoView *scaleView = [[GKDYScaleVideoView alloc] initWithVC:self videos:videos index:index];
    scaleView.videoView.delegate = self;
    [scaleView show];
    
    self.scaleView = scaleView;
}

#pragma  mark  请求数据
-(void)requestData{
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:self.model.user_id forKey:@"user_id_target"];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:dataDic forKey:@"data"];
    [dic setObject:@"view" forKey:@"action"];
    [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];
    NSLog(@"%@",dic);
    [[HttpRequest sharedClient]postWithUrl:YXUserProfile body:dic success:^(NSDictionary *response) {
        NSLog(@"%@",response);
        self.userModel = [YXUserModel mj_objectWithKeyValues:response[@"data"]];
        [self.headerView initData:self.userModel];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - GKPageScrollViewDelegate
- (BOOL)shouldLazyLoadListInPageScrollView:(GKPageScrollView *)pageScrollView {
    return YES;
}

- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.headerView;
}

- (UIView *)segmentedViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.titles.count;
}

- (id<GKPageListViewDelegate>)pageScrollView:(GKPageScrollView *)pageScrollView initListAtIndex:(NSInteger)index {
    GKDYListViewController *listVC = [GKDYListViewController new];
    listVC.target_user_id = self.model.user_id;
    @weakify(self);
    listVC.itemClickBlock = ^(NSArray * _Nonnull videos, NSInteger index) {
        @strongify(self);
        [self showVideoVCWithVideos:videos index:index];
    };
    
    [self addChildViewController:listVC];
    return listVC;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll {
    // 导航栏显隐
    CGFloat offsetY = scrollView.contentOffset.y;
    // 0-200 0
    // 200 - KDYHeaderHeigh - kNavBarheight 渐变从0-1
    // > KDYHeaderHeigh - kNavBarheight 1
    CGFloat alpha = 0;
    if (offsetY < 200) {
        alpha = 0;
    }else if (offsetY > (kUserInfoHeaderHeight - NAVBAR_HEIGHT)) {
        alpha = 1;
    }else {
        alpha = (offsetY - 200) / (kUserInfoHeaderHeight - NAVBAR_HEIGHT - 200);
    }
    self.gk_navBarAlpha = alpha;
    self.titleView.alpha = alpha;

    if (offsetY < 0) {
            [_headerView overScrollAction:offsetY];
        }else {
            [_headerView scrollToTopAction:offsetY];
    //        [self updateNavigationTitle:offsetY];
        }
//    [self.headerView scrollViewDidScroll:offsetY];
}

//私信
-(void)convastaion{
    
  __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];//!!
    __weak typeof(self)weakSelf = self;
    sendMessageCtl.superViewController = self;
    [JMSGConversation createSingleConversationWithUsername:@"sensen" appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            sendMessageCtl.conversation = resultObject;
            JCHATMAINTHREAD(^{
                sendMessageCtl.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            NSLog(@"createSingleConversationWithUsername");
        }
    }];
}

#pragma  mark -  headerDelegate

- (void)onUserActionTap:(NSInteger)tag {
    switch (tag) {
        case UserInfoHeaderAvatarTag: {
//            PhotoView *photoView = [[PhotoView alloc] initWithUrl:_user.avatar_medium.url_list.firstObject];
//            [photoView show];
            break;
        }
            //私信
        case UserInfoHeaderSendTag:
            [self convastaion];
           
            break;
        case UserInfoHeaderFocusCancelTag:
        case UserInfoHeaderFocusTag:{
            if(_headerView) {
                [_headerView requestChangeStatus];
                [_headerView startFocusAnimation];
            }
            break;
        }
        case UserInfoHeaderSettingTag:{
//            MenuPopView *menu = [[MenuPopView alloc] initWithTitles:@[@"清除缓存"]];
//            [menu setOnAction:^(NSInteger index) {
//                [[WebCacheHelpler sharedWebCache] clearCache:^(NSString *cacheSize) {
//                    [UIWindow showTips:[NSString stringWithFormat:@"已经清除%@M缓存",cacheSize]];
//                }];
//            }];
//            [menu show];
            break;
        }
            break;
        case UserInfoHeaderGithubTag:
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/sshiqiao/douyin-ios-objectc"]];
            break;
        default:
            break;
    }
}
#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.currentListVC = (GKDYListViewController *)self.pageScrollView.validListDict[@(index)];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//}
#pragma mark - GKDYVideoViewDelegate
- (void)videoView:(GKDYVideoView *)videoView didClickIcon:(GKDYVideoModel *)videoModel {
    GKDYPersonalViewController *personalVC = [GKDYPersonalViewController new];
    personalVC.model = videoModel;
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)videoView:(GKDYVideoView *)videoView didClickComment:(GKDYVideoModel *)videoModel {
  
}

#pragma mark - GKPageTableViewGestureDelegate
- (BOOL)pageTableView:(GKPageTableView *)tableView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    [self refreshNavBarFrame];
    return self.gk_statusBarHidden;
}

#pragma mark - 懒加载
- (GKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
        _pageScrollView.mainTableView.gestureDelegate = self;
    }
    return _pageScrollView;
}

- (UserInfoHeader *)headerView {
    if (!_headerView) {
        _headerView = [[UserInfoHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kUserInfoHeaderHeight)];
        _headerView.delegate = self;
        
    }
    return _headerView;
}

- (UIView *)pageView {
    if (!_pageView) {
        _pageView = [UIView new];
        _pageView.backgroundColor = [UIColor clearColor];
        
        [_pageView addSubview:self.categoryView];
        [_pageView addSubview:self.scrollView];
    }
    return _pageView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f)];
        _categoryView.backgroundColor = GKColorRGB(34, 33, 37);
        _categoryView.titles = self.titles;
        _categoryView.delegate = self;
        _categoryView.titleColor = [UIColor grayColor];
        _categoryView.titleSelectedColor = [UIColor whiteColor];
        _categoryView.titleFont = [UIFont systemFontOfSize:16.0f];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:16.0f];
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = [UIColor yellowColor];
        lineView.indicatorWidth = 80.0f;
        lineView.indicatorCornerRadius = 0;
        lineView.lineStyle = JXCategoryIndicatorLineStyle_Normal;
        _categoryView.indicators = @[lineView];
        
        _categoryView.contentScrollView = self.pageScrollView.listContainerView.collectionView;
        
        // 添加分割线
        UIView *btmLineView = [UIView new];
        btmLineView.frame = CGRectMake(0, 40 - 0.5, SCREEN_WIDTH, 0.5);
        btmLineView.backgroundColor = GKColorGray(200);
        [_categoryView addSubview:btmLineView];
    }
    return _categoryView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"作品 129", @"说说 129", @"喜欢 591"];
    }
    return _titles;
}

- (UILabel *)titleView {
    if (!_titleView) {
        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
        _titleView.font = [UIFont systemFontOfSize:18.0f];
        _titleView.textColor = [UIColor whiteColor];
        _titleView.alpha = 0;
        
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.text = self.model.author.name_show;
        _titleView.text = @"YAOXIU";
    }
    return _titleView;
}

@end
