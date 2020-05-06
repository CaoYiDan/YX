//
//  GKDYListCollectionViewCell.m
//  GKDYVideo
//
//  Created by gaokun on 2018/12/14.
//  Copyright © 2018 QuintGao. All rights reserved.

#import "YXCommonCityCell.h"
#import "NSDate+Extension.h"
@interface YXCommonCityCell()

@property (nonatomic, strong) UIButton      *starBtn;

/** 头像 */
@property (nonatomic, strong) UIImageView *iconImg;

/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation YXCommonCityCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.coverImgView];
        [self.contentView addSubview:self.starBtn];
//        self.contentView.layer.borderColor = KMainYellowColor.CGColor;
//        self.contentView.layer.borderWidth = 0.4;
        ls_imageView(icon, @"", self.contentView, {
            make.right.offset(-12);
            makeBottomOffSet(self.contentView, -16);
            make.width.offset(28);
            make.height.offset(28);
        })
        
        iconImg.backgroundColor = m_Color_RGB(216, 216, 216);
        ls_cornerRadius(iconImg, 14);
        self.iconImg = iconImg;
        
        ls_label(time, @"3分钟前", m_Color_gray(125), m_FontPF_Regular_WithSize(11), ColorBlack, 0, self.contentView, {
            make.left.offset(KMargin);
            makeBottomOffSet(self.contentView, -8);
            make.height.offset(20);
        })
        self.timeLabel = timeLabel;
        
        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            makeTopOffSet(self.contentView, 0);
            make.right.offset(0);
            make.bottom.offset(-32);
        }];
        
        [self.starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12.0f);
            make.bottom.equalTo(self.contentView).offset(-12.0f-30);
        }];
    }
    return self;
}

- (void)setModel:(GKDYVideoModel *)model {
    _model = model;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:model.first_frame_cover]];
    
    [self.starBtn setTitle:model.agree_num forState:UIControlStateNormal];
    
    self.timeLabel.text = [NSDate formatTime:model.created_at];
}

#pragma mark - 懒加载
- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [UIImageView new];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImgView.clipsToBounds = YES;
    }
    return _coverImgView;
}

- (UIButton *)starBtn {
    if (!_starBtn) {
        _starBtn = [UIButton new];
        [_starBtn setImage:[UIImage imageNamed:@"ss_icon_like"] forState:UIControlStateNormal];
        _starBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_starBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _starBtn;
}

@end
