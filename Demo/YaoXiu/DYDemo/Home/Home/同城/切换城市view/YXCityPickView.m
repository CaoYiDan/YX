//
//  YXCityPickView.m
//  YaoXiu
//
//  Created by MAC on 2020/4/4.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "YXCityPickView.h"

#import "SLLocationHelp.h"

#import "JFCSConfiguration.h"

#import "JFCSDataOpreation.h"

#import "JFCSBaseInfoModel.h"

#import "JFCSTableViewController.h"

@implementation YXCityPickView
{
    UILabel *_pickedCity;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self getLocationCity];
    }
    return self;
}

-(void)initUI{
    
    ls_view(city, ColorBlack, self, {
        make.left.offset(0);
        makeTopOffSet(self, NAVBAR_HEIGHT);
        make.width.offset(ScreenWidth);
        make.height.offset(CityPickViewH);
    })
   
    ls_imageView(location, @"location", self, {
        make.left.offset(KMargin);
        make.centerY.offset(0);
        make.width.offset(9.5);
        make.height.offset(12);
    })
    
    ls_label(showCity, @"自动定位中....", RGB(200, 197, 195), m_FontPF_Regular_WithSize(11.5), ColorBlack, 0, self, {
        make.left.equalTo(locationImg.mas_right).offset(5);
        makeTopOffSet(self, 0);
        make.width.offset(140);
        make.bottom.offset(0);
    })
    _pickedCity = showCityLabel;
    
//    ls_imageView(pick, @"city_arrow", self, {
//        make.right.offset(-KMargin);
//        make.centerY.offset(0);
//        make.width.offset(5);
//        make.height.offset(8);
//    })
//    pickImg.backgroundColor = ColorWhite;
    
//    ls_label(pick, @"切换", RGB(200, 197, 195), m_FontPF_Regular_WithSize(11.5), ColorBlack, NSTextAlignmentRight, self, {
//        make.right.equalTo(pickImg.mas_left).offset(-4);
//        makeTopOffSet(self, 0);
//        make.width.offset(140);
//        make.bottom.offset(0);
//    })
    
}

-(void)getLocationCity{
    
    [[SLLocationHelp sharedInstance]getLocationPlacemark:^(CLPlacemark *placemark) {
        if (placemark.locality)
                {
                    NSLog(@"%@",placemark.locality);
                    _pickedCity.text = [NSString stringWithFormat:@"自动定位 %@",placemark.locality];
                    [self cacheCurrentCity:placemark.locality];
                }
    } status:^(CLAuthorizationStatus status) {
        
    } didFailWithError:^(NSError *error) {
        
    }];
}

-(void)cacheCurrentCity:(NSString *)city{
    
    //暂时不可以点击
    return;
    //自定义配置...
    JFCSConfiguration *config = [[JFCSConfiguration alloc] init];
    config.hiddenHistoricalRecord = YES;
    
    JFCSDataOpreation *cityDataOpreation = [[JFCSDataOpreation alloc]initWithConfiguration:config];
       __weak typeof(cityDataOpreation) weakCityDataOperation = cityDataOpreation;
       [cityDataOpreation searchWithKeyword:city resultBlock:^(NSArray<JFCSBaseInfoModel *> * _Nonnull dataArray) {
           
           if (dataArray.count!=0) {
               [weakCityDataOperation cacheCurrentCity:dataArray[0]];
           }
       }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //自定义配置...
       JFCSConfiguration *config = [[JFCSConfiguration alloc] init];
       config.hiddenHistoricalRecord = YES;
       
       JFCSTableViewController *vc = [[JFCSTableViewController alloc] initWithConfiguration:config delegate:self];
       [[NSObject getCurrentVC].navigationController pushViewController:vc animated:YES];
//    if ([self.delegate respondsToSelector:@selector(cityPickViewDidPickResult:(NSString *)city)]) {
//        [self.delegate cityPickViewDidPickResult:(NSString *)city];
//    }
}

#pragma mark -- JFCSTableViewControllerDelegate

- (void)viewController:(JFCSTableViewController *)viewController didSelectCity:(JFCSBaseInfoModel *)model {
   //选择城市后...
   NSLog(@"name %@ code %zd pinyin %@ alias %@ firstLetter %@",model.name, model.code, model.pinyin, model.alias, model.firstLetter);
    _pickedCity.text = model.name;
}

@end
