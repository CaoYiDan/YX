//
//  YXCityPickView.h
//  YaoXiu
//
//  Created by MAC on 2020/4/4.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFCSTableViewController.h"

//整体高度
#define  CityPickViewH  30

NS_ASSUME_NONNULL_BEGIN

@protocol CityPickDelegate <NSObject>

-(void)cityPickViewDidPickResult:(NSString *)city;

@end

@interface YXCityPickView : UIView<JFCSTableViewControllerDelegate>

/** 代理 */
@property (nonatomic, weak) id<CityPickDelegate> delegate;

-(void)setCity:(NSString *)city;

@end

NS_ASSUME_NONNULL_END
