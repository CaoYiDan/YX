//
//  GKLikeView.h
//  GKDYVideo
//
//  Created by gaokun on 2019/5/27.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GKLikeView;

NS_ASSUME_NONNULL_BEGIN
@protocol LikeViewDelegate <NSObject>

-(void)likeViewDidClick:(GKLikeView*)likeView;

@end

@interface GKLikeView : UIView

/** 代理传递点击事件*/
@property (nonatomic,  weak) id<LikeViewDelegate> delegate;

@property (nonatomic, assign) BOOL      isLike;

- (void)startAnimationWithIsLike:(BOOL)isLike;

- (void)setupLikeState:(BOOL)isLike;

- (void)setupLikeCount:(NSString *)count;


@end

NS_ASSUME_NONNULL_END
