//
//  AttentionListCell.m
//  YaoXiu
//
//  Created by 伯爵 on 2020/3/27.
//  Copyright © 2020 GangMeiTanGongXu. All rights reserved.
//

#import "AttentionListCell.h"

@implementation AttentionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)attentionBtnClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"互相关注"]) {
        [sender setTitle:@"关注" forState:UIControlStateNormal];
        sender.backgroundColor = RGB(250, 212, 72);
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([sender.titleLabel.text isEqualToString:@"关注"]) {
        [sender setTitle:@"互相关注" forState:UIControlStateNormal];
        sender.backgroundColor = RGB(40, 40, 40);
        [sender setTitleColor:RGB(156, 156, 156) forState:UIControlStateNormal];
    }
}


@end
