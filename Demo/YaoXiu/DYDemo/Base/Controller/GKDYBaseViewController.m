//
//  GKDYBaseViewController.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYBaseViewController.h"

@interface GKDYBaseViewController ()

@end

@implementation GKDYBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.gk_navBackgroundColor = m_Color_gray(40);
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
