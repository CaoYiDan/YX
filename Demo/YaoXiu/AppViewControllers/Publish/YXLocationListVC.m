//
//  YXLocationListVC.m
//  YaoXiu
//
//  Created by MAC on 2020/4/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "YXLocationListVC.h"
#import "SLLocationHelp.h"
#import "ZHPlaceInfoModel.h"
#import <CoreLocation/CoreLocation.h>
#import "YXNormalCell.h"

@interface YXLocationListVC ()

@end

@implementation YXLocationListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.backgroundColor = ColorBlack;
    
    [[SLLocationHelp sharedInstance]getLocationPlacemark:^(CLPlacemark *placemark) {
          [self getAroundInfoMationWithCoordinate:placemark.location.coordinate];
    } status:^(CLAuthorizationStatus status) {
        
    } didFailWithError:^(NSError *error) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)getAroundInfoMationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 50, 50);
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.region = region;
    request.naturalLanguageQuery = @"Restaurants";
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        if (!error) {
            [self getAroundInfomation:response.mapItems];
        }else{
           
            NSLog(@"Quest around Error:%@",error.localizedDescription);
        }
    }];
}

-(void)getAroundInfomation:(NSArray *)array
{
    for (MKMapItem *item in array) {
        MKPlacemark * placemark = item.placemark;
        ZHPlaceInfoModel *model = [[ZHPlaceInfoModel alloc]init];
        model.name = placemark.name;
        model.thoroughfare = placemark.thoroughfare;
        model.subThoroughfare = placemark.subThoroughfare;
        model.city = placemark.locality;
        model.coordinate = placemark.location.coordinate;
        [self.dataArr addObject:model];
    }
    [self.tableView reloadData];
}


#pragma  mark  - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXNormalCell *cell = [YXNormalCell loadCode:tableView];
    ZHPlaceInfoModel *model = self.dataArr[indexPath.row];
    [cell setTitle:model.name subTitle:@"" arrowHidden:NO];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHPlaceInfoModel *model = self.dataArr[indexPath.row];
    !self.block?:self.block(model);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
