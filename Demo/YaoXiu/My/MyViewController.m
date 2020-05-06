//
//  MyViewController.m
//  YaoXiu
//
//  Created by 伯爵 on 2019/12/24.
//  Copyright © 2019 GangMeiTanGongXu. All rights reserved.
//

#import "MyViewController.h"
#import "MyTopView.h"
#import "MyOrderCell.h"
#import "MyInfoCell.h"
#import "AttentionListViewController.h"
#import "SendMessageViewController.h"
#import "MessageViewController.h"

@interface MyViewController ()

@end

static NSString *const cellId = @"cellId";

static NSString *const cellId1 = @"cellId1";

@implementation MyViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
 
//    [self createTableView];
//    if (@available(iOS 11.0, *)) {
//            CGFloat a =  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
//    //        NSLog(@"======11   %f",a);
//            if (a > 0) {
//                self.tableView.top = -44;
//                self.tableView.height = self.tableView.height + 44;
//
//            }else{
//                self.tableView.top = -20;
//                self.tableView.height = self.tableView.height + 20;
//            }
//        } else {
//            self.tableView.top = -20;
//            self.tableView.height = self.tableView.height + 20;
//        }
//
//    [self setupView];
 
}

- (void)setupView{
    
    MyTopView *topView = [MyTopView loadFromNIB];
//    [topView.headBtn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = topView;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellId];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyInfoCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellId1];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
         MyOrderCell *cell = [MyOrderCell loadFromNIB];
        if (!cell) {
            cell = [[MyOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        MyInfoCell *cell = [MyInfoCell loadFromNIB];
        if (!cell) {
            cell = [[MyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 286;
    }else{
        return 170;
    }
}

//小二哈
- (IBAction)aaaaaaaaaaBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{
            AttentionListViewController *attentionListVC = [[AttentionListViewController alloc]init];
            [self.navigationController pushViewController:attentionListVC animated:YES];
        }
            break;
        case 200:{
            SendMessageViewController *sendMessageVC = [[SendMessageViewController alloc]init];
            [self.navigationController pushViewController:sendMessageVC animated:YES];
        }
            break;
        case 300:{
            MessageViewController *messageVC = [[MessageViewController alloc]init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}



@end
