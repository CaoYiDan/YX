//
//  SendMessageViewController.m
//  YaoXiu
//
//  Created by 伯爵 on 2020/3/30.
//  Copyright © 2020 GangMeiTanGongXu. All rights reserved.
//

#import "SendMessageViewController.h"
#import "AttentionListCell.h"

@interface SendMessageViewController ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end
static NSString *const cellId = @"cellId";
@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发私信";
    self.view.backgroundColor = [UIColor blackColor];
    [self createTableView];
    [self setupView];
}

- (void)setupView{
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"形状-1"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(20, 7,self.bgView.width-40, 30)];
            //2.searchBar属性设置
    _searchBar.backgroundColor = [UIColor blackColor];
        _searchBar.delegate = self;
            _searchBar.barStyle=UIBarStyleBlack;
            _searchBar.searchBarStyle=UISearchBarStyleMinimal;
            //_searchBar.prompt=@"prompt";
            _searchBar.placeholder=@"电柜名称/地址搜索";
    //        _searchBar.showsBookmarkButton=YES;
            _searchBar.showsCancelButton=NO;
            _searchBar.tintColor=[UIColor whiteColor];
            _searchBar.barTintColor=[UIColor whiteColor];
            _searchBar.translucent=YES;
    //    _searView.backgroundColor = [UIColor whiteColor];
    //    UITextField *searchField=[_searchBar valueForKey:@"_searchField"];
    //
    //    [searchField setValue:[UIColor whiteColor]forKeyPath:@"_placeholderLabel.textColor"];

            //输入框和输入文字的调整
            //白色的那个输入框的偏移
            _searchBar.searchFieldBackgroundPositionAdjustment=UIOffsetMake(5, 0);
            //输入的文字的位置偏移
            _searchBar.searchTextPositionAdjustment=UIOffsetMake(0, 0);
            //特定图片修改
    //        [_searchBar setImage:[UIImage imageNamed:@"1"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
            [self.bgView addSubview:_searchBar];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.top = 88;
    self.tableView.height = self.tableView.height - 88;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AttentionListCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellId];

}

- (void)rightBtn{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    //搜索
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttentionListCell *cell = [AttentionListCell loadFromNIB];
    if (!cell) {
        cell = [[AttentionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


@end
