//
//  GKDYVideoControlView.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYVideoControlView.h"
#import "GKLikeView.h"
#import "FocusView.h"
@interface GKDYVideoItemButton : UIButton

@end

@implementation GKDYVideoItemButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat imgW = self.imageView.frame.size.width;
    CGFloat imgH = self.imageView.frame.size.height;
    
    self.imageView.frame = CGRectMake((width - imgH) / 2, 0, imgW, imgH);
    
    CGFloat titleW = self.titleLabel.frame.size.width;
    CGFloat titleH = self.titleLabel.frame.size.height;
    
    self.titleLabel.frame = CGRectMake((width - titleW) / 2, height - titleH, titleW, titleH);
}

@end

@interface GKDYVideoControlView()<LikeViewDelegate,FocusViewDelegate>

@property (nonatomic, strong) UIImageView           *iconView;
@property (nonatomic, strong) UIImageView           *smallIconView;
@property (nonatomic, strong) GKLikeView            *likeView;
@property (nonatomic, strong) GKDYVideoItemButton   *commentBtn;
@property (nonatomic, strong) GKDYVideoItemButton   *shareBtn;
@property (nonatomic, strong) FocusView   *focus;//头像下边的可点击的”+“按钮
@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) UILabel               *contentLabel;

@property (nonatomic, strong) UIButton                  *playBtn;

@end

@implementation GKDYVideoControlView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.coverImgView];
        [self addSubview:self.iconView];
        [self addSubview:self.focus];
        [self addSubview:self.likeView];
        [self addSubview:self.commentBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.smallIconView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.sliderView];
        
        [self addSubview:self.playBtn];
        
        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGFloat bottomM = TABBAR_HEIGHT;
        
        self.sliderView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT - 0.5, SCREEN_WIDTH, ADAPTATIONRATIO * 1.0f);
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ADAPTATIONRATIO * 30.0f);
            make.bottom.equalTo(self).offset(-(ADAPTATIONRATIO * 30.0f + bottomM));
            make.width.mas_equalTo(ADAPTATIONRATIO * 504.0f);
        }];
        
        [self.smallIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentLabel);
        make.bottom.equalTo(self.contentLabel.mas_top).offset(-ADAPTATIONRATIO * 20.0f);
         make.width.height.mas_equalTo(ADAPTATIONRATIO * 36.0f);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.smallIconView.mas_right).offset(5);
            make.centerY.equalTo(self.smallIconView);
        }];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 10.0f);
            make.bottom.equalTo(self.sliderView.mas_top).offset(-ADAPTATIONRATIO * 100.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.shareBtn.mas_top).offset(-ADAPTATIONRATIO * 45.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.commentBtn.mas_top).offset(-ADAPTATIONRATIO * 45.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.likeView.mas_top).offset(-ADAPTATIONRATIO * 70.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 100.0f);
        }];
        
        [self.focus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.iconView);
        make.centerY.equalTo(self.iconView.mas_bottom);
            make.width.height.mas_equalTo(24);
        }];
        
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (void)setModel:(GKDYVideoModel *)model {
    _model = model;
    
    self.sliderView.value = 0;
    
    if (model.video_width > model.video_height) {
        self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;
    }else {
        self.coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_url] placeholderImage:[UIImage imageNamed:@"img_video_loading"]];
    
    if (![NSString ol_isNullOrNilWithObject:model.author.name_show]) {
         self.nameLabel.text = [NSString stringWithFormat:@"@%@", model.author.name_show];
    }
   
//    self.focus.hidden = model.is_collect;
    
    if ([model.author.portrait containsString:@"http"]) {
         [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.author.portrait] placeholderImage:[UIImage imageNamed:@"placeholderimg"]];
        [self.smallIconView sd_setImageWithURL:[NSURL URLWithString:model.author.portrait] placeholderImage:[UIImage imageNamed:@"placeholderimg"]];
    }else {
        self.iconView.image = [UIImage imageNamed:@"placeholderimg"];
         self.smallIconView.image = [UIImage imageNamed:@"placeholderimg"];
    }
    
    self.contentLabel.text = model.title;
    
    [self.likeView setupLikeState:model.isAgree];
    [self.likeView setupLikeCount:model.agree_num];
    
    [self.commentBtn setTitle:model.comment_num forState:UIControlStateNormal];
    [self.shareBtn setTitle:model.share_num forState:UIControlStateNormal];
}

#pragma mark - Public Methods
- (void)setProgress:(float)progress {
    self.sliderView.value = progress;
}

- (void)startLoading {
    [self.sliderView showLineLoading];
}

- (void)stopLoading {
    [self.sliderView hideLineLoading];
}

- (void)showPlayBtn {
    self.playBtn.hidden = NO;
}

- (void)hidePlayBtn {
    self.playBtn.hidden = YES;
}

- (void)showLikeAnimation {
    [self.likeView startAnimationWithIsLike:YES];
}

- (void)showUnLikeAnimation {
    [self.likeView startAnimationWithIsLike:NO];
}

#pragma mark - Action
- (void)controlViewDidClick {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickSelf:)]) {
        [self.delegate controlViewDidClickSelf:self];
    }
}

- (void)iconDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickIcon:)]) {
        [self.delegate controlViewDidClickIcon:self];
    }
}

//关注用户点击事件
- (void)focusViewDidClick:(FocusView *)view{
    
       NSMutableDictionary *dataDic = @{}.mutableCopy;
       [dataDic setObject:m_UserDefaultObjectForKey(Account_User_ID) forKey:@"user_id"];
       [dataDic setObject:self.model.user_id forKey:@"user_id_target"];
       
       NSMutableDictionary *dic = @{}.mutableCopy;
       [dic setObject:dataDic forKey:@"data"];
       [dic setObject: @"add" forKey:@"action"];
       [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];

       [[HttpRequest sharedClient]postWithUrl:YXUserFollow body:dic success:^(NSDictionary *response) {
        
       } failure:^(NSError *error) {
           
       }];
}

// 点赞 代理
-(void)likeViewDidClick:(GKLikeView *)likeView{
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:self.model.post_id forKey:@"video_id"];
    [dataDic setObject:likeView.isLike?@(1):@(0) forKey:@"status"];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:dataDic forKey:@"data"];
    [dic setObject:@"status" forKey:@"action"];
    [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];
 
    [[HttpRequest sharedClient]postWithUrl:YXUserVideoLike body:dic success:^(NSDictionary *response) {
        
        if ([self.delegate respondsToSelector:@selector(controlViewDidClickPriase:)]) {
            [self.delegate controlViewDidClickPriase:self];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)commentBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickComment:)]) {
        [self.delegate controlViewDidClickComment:self];
    }
}

- (void)shareBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickShare:)]) {
        [self.delegate controlViewDidClickShare:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    NSTimeInterval delayTime = 0.3f;
    
    if (touch.tapCount <= 1) {
        [self performSelector:@selector(controlViewDidClick) withObject:nil afterDelay:delayTime];
    }else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlViewDidClick) object:nil];
        
        if ([self.delegate respondsToSelector:@selector(controlView:touchesBegan:withEvent:)]) {
            [self.delegate controlView:self touchesBegan:touches withEvent:event];
        }
    }
}

#pragma mark - 懒加载
- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [UIImageView new];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImgView.clipsToBounds = YES;
    }
    return _coverImgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.layer.cornerRadius = ADAPTATIONRATIO * 50.0f;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.borderColor = KMainYellowColor.CGColor;
        _iconView.layer.borderWidth = 1.0f;
        _iconView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick:)];
        [_iconView addGestureRecognizer:iconTap];
    }
    return _iconView;
}
- (UIImageView *)smallIconView {
    if (!_smallIconView) {
        _smallIconView = [UIImageView new];
        _smallIconView.layer.cornerRadius = ADAPTATIONRATIO * 36.0f/2.0;
        _smallIconView.layer.masksToBounds = YES;
        _smallIconView.layer.borderColor = ColorWhite.CGColor;
        _smallIconView.layer.borderWidth = 0.8f;
        _smallIconView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick:)];
        [_smallIconView addGestureRecognizer:iconTap];
    }
    return _smallIconView;
}

- (GKLikeView *)likeView {
    if (!_likeView) {
        _likeView = [GKLikeView new];
        _likeView.delegate = self;
    }
    return _likeView;
}

- (GKDYVideoItemButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [GKDYVideoItemButton new];
        [_commentBtn setImage:[UIImage imageNamed:@"icon_home_comment"] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (GKDYVideoItemButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [GKDYVideoItemButton new];
        [_shareBtn setImage:[UIImage imageNamed:@"icon_home_share"] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = KMainYellowColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _nameLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick:)];
        [_nameLabel addGestureRecognizer:nameTap];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _contentLabel;
}

- (GKSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [GKSliderView new];
        _sliderView.isHideSliderBlock = YES;
        _sliderView.sliderHeight = ADAPTATIONRATIO * 1.0f;
        _sliderView.maximumTrackTintColor = [UIColor clearColor];
        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
    }
    return _sliderView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"ss_icon_pause"] forState:UIControlStateNormal];
        _playBtn.hidden = YES;
    }
    return _playBtn;
}

- (FocusView *)focus{
    if (!_focus) {
        _focus = [[FocusView alloc]init];
        _focus.delegate = self;
//        _focus.hidden = YES;
    }
    return _focus;
}

@end
