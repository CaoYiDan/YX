//
//  MessageViewController.m
//  YaoXiu
//
//  Created by 伯爵 on 2020/3/30.
//  Copyright © 2020 GangMeiTanGongXu. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageSxCell.h"
#import "MessageZpCell.h"

@interface MessageViewController ()

@property (nonatomic ,assign)NSInteger index;

@end
static NSString *const cellId = @"cellId";
static NSString *const cellId1 = @"cellId1";

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
//    self.view.backgroundColor = [UIColor blackColor];
    self.index = 100;
    [self createTableView];
    [self setupView];
}

- (void)setupView{
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.top = 88;
    self.tableView.height = self.tableView.height - 88;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageSxCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellId];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageZpCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellId1];

}

- (IBAction)chooseBtnClick:(UIButton *)sender {
    self.index = sender.tag;
    [self.tableView reloadData];
    if (sender.tag == 100) {
        
    }else if (sender.tag == 200){
        
    }else{
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 100) {
        MessageSxCell *cell = [MessageSxCell loadFromNIB];
        if (!cell) {
            cell = [[MessageSxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (self.index == 200){
        MessageZpCell *cell = [MessageZpCell loadFromNIB];
        if (!cell) {
            cell = [[MessageZpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        MessageZpCell *cell = [MessageZpCell loadFromNIB];
        if (!cell) {
            cell = [[MessageZpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
        cell.titleLab.text = @"王二丫加持了10朵玫瑰";
        cell.timeLab.text = @"2020-06-28";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


@end
