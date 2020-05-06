//
//  JFCSTableViewHeaderView.m
//  jfcityselector
//
//  Created by zhifenx on 2019/7/24.
//  Copyright © 2019 zhifenx. All rights reserved.
//

#import "JFCSTableViewHeaderView.h"

#import "JFCSFileManager.h"

@implementation JFCSTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIFont *font = [UIFont systemFontOfSize:13.0];
        CGFloat buttonW = 100;
        CGFloat buttonR = 16;
        CGFloat buttonX = KMargin;
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 35, buttonW, 36)];
        self.rightButton.backgroundColor = RGB(40, 40, 40);
        [self.rightButton.titleLabel setFont:font];
        [self.rightButton setTitleColor:m_Color_gray(156) forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        ls_cornerRadius(self.rightButton, 3.5);
        [self addSubview:self.rightButton];
      
        CGFloat labelW = 100;
        self.currentCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonR, 0, labelW, 30)];
        self.currentCityLabel.font = m_FontPF_Medium_WithSize(13);
        self.currentCityLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.currentCityLabel.textColor = m_Color_gray(156);
        [self addSubview:self.currentCityLabel];
        [self updateCurrentCity:@""];
    }
    return self;
}

- (void)updateCurrentCity:(NSString *)name {
    if (name) {
        self.currentCityLabel.text = [NSString stringWithFormat:@"当前城市：%@",@""];
        [self.rightButton setTitle:name forState:UIControlStateNormal];
    }
}

- (void)rightButtonAction:(UIButton *)sender {
    
    self.headerBlock(YES);
}

- (void)headerViewBlock:(headerViewBlock)blcok {
    if (blcok) {
        self.headerBlock = blcok;
    }
}

@end
