//
//  BaseViewController.m
//  Pos
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = RGB(236, 237, 238);
    
}



- (void)noDataLabel{
    self.lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.lab.text = @"暂无数据";
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:self.lab];
}

- (void)noDataImg{
    self.img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    self.img.image = [UIImage imageNamed:@"noaddress"];
    self.img.contentMode =  UIViewContentModeCenter;
    [self.view addSubview:self.img];
}

@end
