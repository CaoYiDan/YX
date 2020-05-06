//
//  UILabel+Extension.m
//  XCFApp
//
//  Created by callmejoejoe on 16/4/5.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (UILabel *)labelWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
             numberOfLines:(NSInteger)lines
             textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = lines;
    label.textAlignment = textAlignment;
    
    return label;
}


-(void)setAttributeTextWithString:(NSString *)string range:(NSRange)range WithColour:(UIColor *)color{
    NSMutableAttributedString *attrsString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrsString addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = attrsString;
}

-(void)setAttributeTextWithString:(NSString *)string range:(NSRange)range WithFont:(UIFont *)font{
    NSMutableAttributedString *attrsString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrsString addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = attrsString;
}

- (void)setAttributedStringWithFirstString:(NSString *)firstString withFirstColour:(UIColor *)firstColour withFirstFont:(UIFont *)firstFont withSecondString:(NSString *)secondString withSecondColour:(UIColor *)secondColour withSecondFont:(UIFont *)secondFont{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",firstString, secondString]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:firstColour range:NSMakeRange(0,firstString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value: secondColour range:NSMakeRange(firstString.length , secondString.length)];
    
    [attributedString addAttribute:NSFontAttributeName value:firstFont range:NSMakeRange(0, firstString.length)];
    [attributedString addAttribute:NSFontAttributeName value:secondFont range:NSMakeRange(firstString.length, secondString.length)];
    
    self.attributedText = attributedString;
}



@end
