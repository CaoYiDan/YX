//
//  FocusView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FocusView;

@protocol FocusViewDelegate <NSObject>

-(void)focusViewDidClick:(FocusView *)view;

@end

@interface FocusView : UIImageView
/**/
@property (nonatomic, weak) id<FocusViewDelegate> delegate;

- (void)resetView;

@end
