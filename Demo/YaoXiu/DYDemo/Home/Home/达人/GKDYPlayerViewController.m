//
//  GKDYPlayerViewController.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYPlayerViewController.h"
#import "UIImage+GKCategory.h"
#import "GKDYPersonalViewController.h"
#import "GKSlidePopupView.h"

#import "GKBallLoadingView.h"
#import "GKLikeView.h"
#import "SharePopView.h"
#import "CommentsPopView.h"

#import "TCVideoListViewController.h"
#define kTitleViewY         (GK_SAFEAREA_TOP + 20.0f)
// 过渡中心点
#define kTransitionCenter   20.0f

@interface GKDYPlayerViewController ()<GKDYVideoViewDelegate, GKViewControllerPushDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView                *titleView;

@property (nonatomic, strong) UIView                *refreshView;
@property (nonatomic, strong) UILabel               *refreshLabel;
@property (nonatomic, strong) UIView                *loadingBgView;
@property (nonatomic, strong) GKBallLoadingView     *refreshLoadingView;

@property (nonatomic, strong) UIButton              *backBtn;

@property (nonatomic, strong) GKDYVideoModel        *model;
@property (nonatomic, strong) NSArray               *videos;
@property (nonatomic, assign) NSInteger             playIndex;

// 是否从某个控制器push过来
@property (nonatomic, assign) BOOL                  isPushed;
@property (nonatomic, assign) BOOL                  isRefreshing;

@end

@implementation GKDYPlayerViewController

- (instancetype)initWithVideoModel:(GKDYVideoModel *)model {
    if (self = [super init]) {
        
        self.model = model;
        
        self.isPushed = YES;
    }
    return self;
}

- (instancetype)initWithVideos:(NSArray *)videos index:(NSInteger)index {
    if (self = [super init]) {
        self.videos = videos;
        self.playIndex = index;
        
        self.isPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.gk_navigationBar.hidden = YES;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.view addSubview:self.videoView];
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.isPushed) {
        [self.view addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15.0f);
            make.top.equalTo(self.view).offset(GK_SAFEAREA_TOP + 20.0f);
            make.width.height.mas_equalTo(44.0f);
        }];
        
        [self.videoView setModels:self.videos index:self.playIndex];
        
    }else {
        
        [self.view addSubview:self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.left.right.equalTo(self.view);
                  make.top.equalTo(self.view).offset(GK_SAFEAREA_TOP + 20.0f);
                  make.height.mas_equalTo(44.0f);
              }];
        
        [self.view addSubview:self.refreshView];
        [self.refreshView addSubview:self.refreshLabel];
        [self.view addSubview:self.loadingBgView];
        
        self.loadingBgView.frame = CGRectMake(SCREEN_WIDTH - 15 - 44, GK_SAFEAREA_TOP, 44, 44);
        self.refreshLoadingView = [GKBallLoadingView loadingViewInView:self.loadingBgView];
        
        [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(GK_SAFEAREA_BTM + 20.0f);
            make.height.mas_equalTo(44.0f);
        }];
        
        [self.refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.refreshView);
        }];
        self.titleView.hidden = YES;
        
        [self refreshData];
        //加载动画
//          GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.view];
//          [loadingView startLoading];
//        @weakify(self);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            @strongify(self);
//
//            [loadingView stopLoading];
//            [loadingView removeFromSuperview];
//
//            [self.videoView.viewModel refreshNewListWithSuccess:^(NSArray * _Nonnull list) {
//                [self.videoView setModels:list index:0];
//            } failure:^(NSError * _Nonnull error) {
//
//            }];
//        });
         
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (!self.isPushed) {
        self.gk_pushDelegate = self;
    }
    
    [self.videoView resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!self.isPushed) {
        self.gk_pushDelegate = nil;
    }
    
    // 停止播放
    [self.videoView pause];
}

- (void)dealloc {
    
    [self.videoView destoryPlayer];
    
    NSLog(@"playerVC dealloc");
}

#pragma mark - 刷新数据

-(void)refreshData{
    
   //加载动画
   GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.view];
   [loadingView startLoading];
    
    [self.refreshLoadingView startLoading];
    self.isRefreshing = YES;
     
    @weakify(self);
    [self.videoView.viewModel refreshNewListWithSuccess:^(NSArray * _Nonnull list) {
        
        @strongify(self);
        
        [loadingView stopLoading];
        [loadingView removeFromSuperview];
        
        [self.videoView setModels:list index:0];
         
        [self.refreshLoadingView stopLoading];
        self.loadingBgView.alpha = 0;
                       
         self.isRefreshing = NO;
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GKViewControllerPushDelegate
- (void)pushToNextViewController {
    GKDYPersonalViewController *personalVC = [GKDYPersonalViewController new];
    personalVC.model = self.videoView.currentPlayView.model;
    [self.navigationController pushViewController:personalVC animated:YES];
}

#pragma mark - GKDYVideoViewDelegate
- (void)videoView:(GKDYVideoView *)videoView didClickIcon:(GKDYVideoModel *)videoModel {
    
    GKDYPersonalViewController *personalVC = [GKDYPersonalViewController new];
    personalVC.model = videoModel;
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)videoView:(GKDYVideoView *)videoView didClickPraise:(GKDYVideoModel *)videoModel {
   
    GKDYVideoModel *model = videoModel;
    
    model.isAgree = !model.isAgree;
    
    int agreeNum = model.agree_num.intValue;
    
    if (model.isAgree) {
        model.agree_num = [NSString stringWithFormat:@"%d", agreeNum + 1];
    }else {
        model.agree_num = [NSString stringWithFormat:@"%d", agreeNum - 1];
    }
    
    videoView.currentPlayView.model = videoModel;
}

- (void)videoView:(GKDYVideoView *)videoView didClickComment:(GKDYVideoModel *)videoModel {

    CommentsPopView *popView = [[CommentsPopView alloc] initWithAwemeId:videoModel.post_id];
    popView.totalCommentNum = videoModel.comment_num;
    [popView show];
    
}

- (void)videoView:(GKDYVideoView *)videoView didClickShare:(GKDYVideoModel *)videoModel {
    
    SharePopView *popView = [[SharePopView alloc] init];
    [popView show];
}

- (void)videoView:(GKDYVideoView *)videoView didScrollIsCritical:(BOOL)isCritical {
    if ([self.delegate respondsToSelector:@selector(playerVC:controlView:isCritical:)]) {
        [self.delegate playerVC:self controlView:videoView.currentPlayView isCritical:isCritical];
    }
}

- (void)videoView:(GKDYVideoView *)videoView didPanWithDistance:(CGFloat)distance isEnd:(BOOL)isEnd {
    if (self.isRefreshing) return;
    
    if (isEnd) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.titleView.frame;
            frame.origin.y = kTitleViewY;
            self.titleView.frame = frame;
            self.refreshView.frame = frame;
            
            CGRect loadingFrame = self.loadingBgView.frame;
            loadingFrame.origin.y = kTitleViewY;
            self.loadingBgView.frame = loadingFrame;
            
            self.refreshView.alpha      = 0;
            self.titleView.alpha        = 1;
            self.loadingBgView.alpha    = 1;
        }];
        
        if (distance >= 2 * kTransitionCenter) { // 刷新
            [self refreshData];
            
        }else {
            self.loadingBgView.alpha = 0;
        }
    }else {
        if (distance < 0) {
            self.refreshView.alpha = 0;
            self.titleView.alpha = 1;
        }else if (distance > 0 && distance < kTransitionCenter) {
            CGFloat alpha = distance / kTransitionCenter;
            
            self.refreshView.alpha      = 0;
            self.titleView.alpha        = 1 - alpha;
            self.loadingBgView.alpha    = 0;
            
            // 位置改变
            CGRect frame = self.titleView.frame;
            frame.origin.y = kTitleViewY + distance;
            self.titleView.frame = frame;
            self.refreshView.frame = frame;
            
            CGRect loadingFrame = self.loadingBgView.frame;
            loadingFrame.origin.y = frame.origin.y;
            self.loadingBgView.frame = loadingFrame;
        }else if (distance >= kTransitionCenter && distance <= 2 * kTransitionCenter) {
            CGFloat alpha = (2 * kTransitionCenter - distance) / kTransitionCenter;
            
            self.refreshView.alpha      = 1 - alpha;
            self.titleView.alpha        = 0;
            self.loadingBgView.alpha    = 1 - alpha;
            
            // 位置改变
            CGRect frame = self.titleView.frame;
            frame.origin.y = kTitleViewY + distance;
            self.titleView.frame    = frame;
            self.refreshView.frame  = frame;
            
            CGRect loadingFrame = self.loadingBgView.frame;
            loadingFrame.origin.y = frame.origin.y;
            self.loadingBgView.frame = loadingFrame;
            
            [self.refreshLoadingView startLoadingWithProgress:(1 - alpha)];
        }else {
            self.titleView.alpha    = 0;
            self.refreshView.alpha  = 1;
            self.loadingBgView.alpha = 1;
            [self.refreshLoadingView startLoadingWithProgress:1];
        }
    }
}

#pragma mark - 懒加载
- (GKDYVideoView *)videoView {
    if (!_videoView) {
        if (_isPushed) {
            _videoView = [[GKDYVideoView alloc] initFromListPushedWithVC:self];
        }else{
             _videoView = [[GKDYVideoView alloc] initWithVC:self isPushed:self.isPushed];
        }
       
        _videoView.delegate = self;
    }
    return _videoView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage gk_imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [UIView new];
    }
    return _titleView;
}

- (UIView *)refreshView {
    if (!_refreshView) {
        _refreshView = [UIView new];
        _refreshView.backgroundColor = [UIColor clearColor];
        _refreshView.alpha = 0.0f;
    }
    return _refreshView;
}

- (UILabel *)refreshLabel {
    if (!_refreshLabel) {
        _refreshLabel = [UILabel new];
        _refreshLabel.font = [UIFont systemFontOfSize:16.0f];
        _refreshLabel.text = @"下拉刷新内容";
        _refreshLabel.textColor = [UIColor whiteColor];
    }
    return _refreshLabel;
}

- (UIView *)loadingBgView {
    if (!_loadingBgView) {
        _loadingBgView = [UIView new];
        _loadingBgView.backgroundColor = [UIColor clearColor];
        _loadingBgView.alpha = 0.0f;
    }
    return _loadingBgView;
}

@end
