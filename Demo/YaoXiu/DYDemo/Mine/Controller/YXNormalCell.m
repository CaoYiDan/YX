//
//  YXNormalCell.m
//  YaoXiu
//
//  Created by MAC on 2020/4/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "YXNormalCell.h"

@implementation YXNormalCell
{
    UILabel *_leftTitle;
    UILabel *_rightSubTitle;
    UIImageView *_arrow;
}

- (void)initUI{
    
    self.backgroundColor = ColorBlack;
    
    ls_label( left, @"", m_Color_gray(231), m_FontPF_Regular_WithSize(15),ColorClear, 0, self, {
        make.left.offset(16);
        makeTopOffSet(self, 0);
        make.bottom.offset(0);
    })
    _leftTitle = leftLabel;
    
    ls_label(subTitle, @"",m_Color_RGB(126, 128, 133), m_FontPF_Regular_WithSize(14),ColorClear, NSTextAlignmentRight, self, {
        make.right.offset(-35);
        makeTopOffSet(self, 0);
        make.bottom.offset(0);
    })
    _rightSubTitle = subTitleLabel;
    
    ls_imageView(arrow, @"city_arrow", self, {
        make.right.offset(-KMargin);
        make.centerY.offset(0);
        make.width.offset(7.2);
        make.height.offset(11.9);
    })
    _arrow = arrowImg;
    
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle arrowHidden:(BOOL)arrowHidden{
    _leftTitle.text = title;
    _rightSubTitle.text = subTitle;
    _arrow.hidden = arrowHidden;
}

@end
