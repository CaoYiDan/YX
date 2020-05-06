//
//  YXEditIconView.m
//  YaoXiu
//
//  Created by MAC on 2020/4/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "YXEditIconView.h"

@implementation YXEditIconView
{
    UIImageView *_iconImage;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    self.backgroundColor = [UIColor blackColor];
    ls_imageView(icon, @"", self, {
        make.center.offset(0);
        make.width.offset(74);
        make.height.offset(74);
    })
    _iconImage = iconImg;
    _iconImage.backgroundColor = RGB(216, 216, 216);
    iconImg.userInteractionEnabled = YES;
    ls_cornerRadius(_iconImage, 74/2);
    
    ls_label(tip, @"点击更换头像", m_Color_gray(226), m_FontPF_Regular_WithSize(13), ColorBlack, NSTextAlignmentCenter, self, {
        make.left.offset(0);
        makeTopOffSet(iconImg.mas_bottom, 14);
        make.width.offset(ScreenWidth);
        make.height.offset(20);
    })
    tipLabel.userInteractionEnabled =  YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"dianhi le ");
}

-(void)setHeaderUrl:(NSString *)url{
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:url]];
    
}
@end
