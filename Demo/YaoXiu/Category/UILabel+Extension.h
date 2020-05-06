//
//  UILabel+Extension.h
//  XCFApp
//
//  Created by callmejoejoe on 16/4/5.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+ (UILabel *)labelWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
             numberOfLines:(NSInteger)lines
             textAlignment:(NSTextAlignment)textAlignment;


/**
 *  快速设置富文本
 *
 *  @param string 需要设置的字符串
 *  @param range  需要设置的范围（范围文字颜色显示为下厨房橘红色）
 */
//仅设置字体不同
-(void)setAttributeTextWithString:(NSString *)string range:(NSRange)range WithFont:(UIFont *)font;
//仅设置颜色不同
- (void)setAttributeTextWithString:(NSString *)string range:(NSRange)range WithColour:(UIColor*)color;

/// 颜色和字体都不同

- (void)setAttributedStringWithFirstString:(NSString *)firstString withFirstColour:(UIColor*)firstColour withFirstFont:(UIFont *)firstFont withSecondString:(NSString *)secondString withSecondColour:(UIColor*)secondColour withSecondFont:(UIFont *)secondFont;

@end
