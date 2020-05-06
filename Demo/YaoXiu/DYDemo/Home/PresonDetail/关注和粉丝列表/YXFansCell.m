//
//  YXFansCell.m
//  YaoXiu
//
//  Created by MAC on 2020/4/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "YXFansCell.h"
#import "YXUserModel.h"

@implementation YXFansCell
{
    UIImageView *_icon;
    UILabel *_name;
    UILabel *_subTitle;
    UIButton *_sendMessage;
}

- (void)initUI{
    
    self.backgroundColor = ColorBlack;
    
    ls_imageView(icon, @"", self, {
        make.left.offset(KMargin);
        make.centerY.offset(0);
        make.width.offset(45);
        make.height.offset(45);
    })
    ls_cornerRadius(iconImg, 22.5);
    iconImg.backgroundColor = m_Color_gray(216);
    _icon = iconImg;
    
    ls_label(nickName, @"", m_Color_RGB(233, 233, 233), m_FontPF_Regular_WithSize(14),ColorClear, 0, self, {
        make.left.equalTo(iconImg.mas_right).offset(7.5);
        makeTopOffSet(iconImg, 0);
        make.height.offset(20);
    })
    _name = nickNameLabel;
    
    ls_label(sub, @"dsddssd", m_Color_RGB(156, 156, 156), m_FontPF_Regular_WithSize(12),ColorClear, 0, self, {
        make.left.equalTo(nickNameLabel).offset(0);
        makeTopOffSet(nickNameLabel.mas_bottom, 5);
        make.height.offset(20);
    })
    _subTitle = subLabel;
    
    ls_button(sendM, @"私信", m_FontPF_Regular_WithSize(13), m_Color_gray(156), @"", m_Color_gray(40), 2, self, {
        make.right.offset(-KMargin);
        make.centerY.offset(0);
        make.width.offset(74);
        make.height.offset(24);
    }, {
        
    })
    _sendMessage  = sendMButton;
}

- (void)setModel:(YXUserModel *)model{
    _model = model;
    _name.text = model.user_nick_name;
    _subTitle.text = model.user_introduction;
    
}

@end
