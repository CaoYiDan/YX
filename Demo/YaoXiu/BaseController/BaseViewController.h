//
//  BaseViewController.h
//  Pos
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic ,strong)UILabel *lab;
@property (nonatomic ,strong)UIImageView *img;

- (void)noDataImg;

- (void)noDataLabel;



@end
