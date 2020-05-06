//
//  GKDYListViewController.m
//  GKDYVideo
//
//  Created by gaokun on 2018/12/14.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYListViewController.h"
#import "GKDYListCollectionViewCell.h"
#import "GKDYVideoViewController.h"
#import "GKBallLoadingView.h"
#import "GKDYVideoViewModel.h"
@interface GKDYListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIView            *loadingBgView;

@property (nonatomic, strong) GKDYVideoViewModel    *viewModel;

@property (nonatomic, strong) NSMutableArray    *videos;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, assign) BOOL              isRefresh;
@property (nonatomic, assign) NSInteger         index;

@end

@implementation GKDYListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationBar.hidden = YES;
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.index ++ ;
        
        [self.viewModel refreshMoreListWithSuccess:^(NSArray * _Nonnull list) {
            
            [self.videos addObjectsFromArray:list];
                   [self.collectionView reloadData];
                   
            [self.collectionView.mj_footer endRefreshing];
            
        } failure:^(NSError * _Nonnull error) {
            
        }];

    }];
    
    [self.view addSubview:self.loadingBgView];
    self.loadingBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ADAPTATIONRATIO * 400.0f);
    
    GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.loadingBgView];
    [loadingView startLoading];
    
    [self.viewModel refreshNewListWithSuccess:^(NSArray * _Nonnull list) {
        
        [loadingView stopLoading];
        [loadingView removeFromSuperview];
        self.loadingBgView.hidden = YES;
        self.index = 1;
        
        self.isRefresh = YES;
        
        [self.videos removeAllObjects];
        [self.videos addObjectsFromArray:list];
        
        [self.collectionView.mj_header endRefreshing];
        
        [self.collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
  
}

- (void)refreshData {
    if (self.isRefresh) return;
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GKDYListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GKDYListCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.videos[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.item;
    
//    GKDYVideoViewController *playerVC = [[GKDYVideoViewController alloc] initWithVideos:self.videos index:indexPath.item];
//    [self.navigationController pushViewController:playerVC animated:YES];
    
    !self.itemClickBlock ? : self.itemClickBlock(self.videos, indexPath.item);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ? : self.scrollCallback(scrollView);
}

#pragma mark - GKPageListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = (SCREEN_WIDTH - 2) / 3;
        CGFloat height = width * 16 / 9;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(width, height);
        layout.minimumLineSpacing = 1.0f;
        layout.minimumInteritemSpacing = 1.0f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[GKDYListCollectionViewCell class] forCellWithReuseIdentifier:@"GKDYListCollectionViewCell"];
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (UIView *)loadingBgView {
    if (!_loadingBgView) {
        _loadingBgView = [UIView new];
    }
    return _loadingBgView;
}

- (NSMutableArray *)videos {
    if (!_videos) {
        _videos = [NSMutableArray new];
    }
    return _videos;
}

- (GKDYVideoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [GKDYVideoViewModel new];
        _viewModel.requestType = RequestTypeSomeOne;
        _viewModel.target_user_id = self.target_user_id;
    }
    return _viewModel;
}
@end
