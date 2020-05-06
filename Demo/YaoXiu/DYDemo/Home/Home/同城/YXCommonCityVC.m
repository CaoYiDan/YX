//
//  GKDYListViewController.m
//  GKDYVideo
//
//  Created by gaokun on 2018/12/14.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "YXCommonCityVC.h"
#import "YXCityPickView.h"
#import "GKDYPlayerViewController.h"
#import "SDDiskCache.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "JFCSDataOpreation.h"
#import "JFCSConfiguration.h"
#import "JFCSTableViewController.h"
#import "YXCommonCityCell.h"
#import "GKDYScaleVideoView.h"
#import "GKDYVideoViewController.h"
#import "GKBallLoadingView.h"
#import "GKDYVideoViewModel.h"
#import "LJJWaterFlowLayout.h"

@interface YXCommonCityVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate,CityPickDelegate,JFCSTableViewControllerDelegate>

@property (nonatomic, strong) UIView            *loadingBgView;

@property (nonatomic, strong) GKDYVideoViewModel    *viewModel;

@property (nonatomic, strong) NSMutableArray    *videos;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, assign) BOOL              isRefresh;

@property (nonatomic, assign) NSInteger         index;

/** 城市选择 */
@property (nonatomic, strong) YXCityPickView *cityPickView;

@end

@implementation YXCommonCityVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.gk_navigationBar.hidden = YES;
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.cityPickView];
    
    self.view.backgroundColor = m_Color_gray(40);
    
    //上下分割线的高度
    CGFloat sepLineH = 0.5;
    
    ls_view(topLine, ColorWhite, self.view, {
          make.left.offset(0);
          makeTopOffSet(self.view, SafeAreaTopHeight);
          make.width.offset(ScreenWidth);
          make.height.offset(sepLineH);
      })
    
    ls_view(bottomLine, ColorWhite, self.view, {
          make.left.offset(0);
          makeBottomOffSet(self.view, -SafeAreaBottomHeight-TABBAR_HEIGHT);
          make.width.offset(ScreenWidth);
          make.height.offset(sepLineH);
      })
    
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
    
  self.collectionView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
      
      GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.loadingBgView];
       [loadingView startLoading];
       self.loadingBgView.hidden = NO;
      
       self.index = 1;
       
       [self.viewModel refreshNewListWithSuccess:^(NSArray * _Nonnull list) {
           
           [loadingView stopLoading];
           [loadingView removeFromSuperview];
           self.loadingBgView.hidden = YES;
           self.isRefresh = NO;
           
           [self.videos removeAllObjects];
           [self.videos addObjectsFromArray:list];
           
           [self.collectionView.mj_header endRefreshing];
           
           [self.collectionView reloadData];
           
           [self.collectionView.mj_header endRefreshing];
           
       } failure:^(NSError * _Nonnull error) {
           
       }];
      
  }];
  
  [self.collectionView.mj_header beginRefreshing];
    
    WeakSelf;
    //获取更多的通知
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:VideoNeedLoadMoreNotification object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        //加载更多
        [weakSelf.viewModel refreshMoreListWithSuccess:^(NSArray * _Nonnull list) {
            
            [weakSelf.videos addObjectsFromArray:list];
            [weakSelf.collectionView reloadData];
        
            [[NSNotificationCenter defaultCenter]postNotificationName:VideoHaveLoadMoreNotification object:list userInfo:nil];
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
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
    YXCommonCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXCommonCityCell" forIndexPath:indexPath];
    cell.model = self.videos[indexPath.row];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//   GKDYVideoModel *model = self.videos[indexPath.row];
//    CGFloat cellH = [self p_getCellHeightWithImageUrl:model.first_frame_cover];
    //获取一个随机整数范围在：[0,100)包括0，不包括100
    int x = arc4random() % 50;
    CGFloat cellH = indexPath.row%2==0?240:270;
    cellH += x;
   return CGSizeMake((ScreenWidth-2)/2, cellH);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 0, 1, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.item;
    
   GKDYPlayerViewController *playerVC = [[GKDYPlayerViewController alloc] initWithVideos:self.videos index:indexPath.item];
    [self.navigationController pushViewController:playerVC animated:YES];
}

//根据网络图片 获取图片的宽高比列
-(CGFloat)p_getCellHeightWithImageUrl:(NSString *)imageUrl{
    
     __block CGFloat itemW = (ScreenWidth-2)/2;

    __block CGFloat itemH = 0;


//    UIImageView * imageView = [[UIImageView alloc] init];

    NSURL * url = [NSURL URLWithString:imageUrl];

//    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];

    UIImage * image;

    image = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageUrl];
    
  
    if (image) {
        
        NSLog(@"fd");
        
    }else{

        NSData *data = [NSData dataWithContentsOfURL:url];

        image = [UIImage imageWithData:data];

    }

    //根据image的比例来设置高度

    if (image.size.width) {

        itemH = image.size.height / image.size.width * itemW;

        

        if (itemH <= itemW) {

            itemH = 230;

        }
        
    }
    return itemH;
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
        
        LJJWaterFlowLayout *layout = [[LJJWaterFlowLayout alloc]init];
    
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, ScreenWidth, ScreenHeight-NAVBAR_HEIGHT-TABBAR_HEIGHT)
                                                 collectionViewLayout:layout];
        if (@available(iOS 11, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentInset = UIEdgeInsetsMake(CityPickViewH, 0, 0, 0);
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[YXCommonCityCell class] forCellWithReuseIdentifier:@"YXCommonCityCell"];
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
        _viewModel.requestType = RequestTypeCommonCity;
    }
    return _viewModel;
}

-(YXCityPickView *)cityPickView{
    if (!_cityPickView) {
        _cityPickView = [[YXCityPickView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CityPickViewH)];
        _cityPickView.backgroundColor = ColorBlack;
        _cityPickView.delegate = self;
    }
    return _cityPickView;
}

#pragma  mark  点击了切换城市
- (void)cityPickViewDidPickResult:(NSString *)city{

}

@end
