//
//  CommentsPopView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.

#import "UIImageView+WebCache.h"
#import "CommentsPopView.h"
#import "MenuPopView.h"
#import "YXVideoCommentModel.h"
#import "NSNotification+Extension.h"
#import "NSAttributedString+Extension.h"
#import "NSString+Extension.h"
#import "NSDate+Extension.h"
#import "LoadMoreControl.h"
//#import "NetworkHelper.h"
#import "YXVideoCommentModel.h"

NSString * const kCommentListCell     = @"CommentListCell";
NSString * const kCommentListSamllCell= @"CommentListSmallCell";
NSString * const kCommentHeaderCell   = @"CommentHeaderCell";
NSString * const kCommentFooterCell   = @"CommentFooterCell";

@interface CommentsPopView () <UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate,UIScrollViewDelegate, CommentTextViewDelegate>

@property (nonatomic, assign) NSString                         *awemeId;
//@property (nonatomic, strong) Visitor                          *vistor;

@property (nonatomic, assign) NSInteger                        pageIndex;
@property (nonatomic, assign) NSInteger                        pageSize;

@property (nonatomic, strong) UIView                           *container;
@property (nonatomic, strong) UITableView                      *tableView;
@property (nonatomic, strong) NSMutableArray       *data;
@property (nonatomic, strong) CommentTextView                  *textView;
@property (nonatomic, strong) LoadMoreControl                  *loadMore;

/** 当前要回复的评论模型 */
@property (nonatomic, strong) YXVideoCommentModel *selectedCommentModel;

/** 将要展开更多评论的评论模型 */
@property (nonatomic, strong) YXVideoCommentModel *willShowMoreCommentModel;

@end


@implementation CommentsPopView

- (instancetype)initWithAwemeId:(NSString *)awemeId {
    self = [super init];
    if (self) {
        self.frame = ScreenFrame;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        _awemeId = awemeId;
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];\
//        NSDictionary *dic = [defaults objectForKey:@"visitor"];\
//
//        _vistor = [Visitor yy_modelWithDictionary:dic];;
        
        //默认评论视频
        _commentType = commentType_video;
        
        _pageIndex = 0;
        _pageSize = 10;
        
        _data = [NSMutableArray array];
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight*3/4)];
        _container.backgroundColor = ColorWhite;
        [self addSubview:_container];
        
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight*3/4) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _container.layer.mask = shape;
        
//        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//        visualEffectView.frame = self.bounds;
//        visualEffectView.alpha = 1.0f;
//        [_container addSubview:visualEffectView];
        
        
        _label = [[UILabel alloc] init];
        _label.textColor = ColorGray;
        _label.text = @"0条评论";
        _label.font = SmallFont;
        _label.textAlignment = NSTextAlignmentCenter;
        [_container addSubview:_label];
        
        
        ls_imageView(close, @"closecomment", _container, {
            make.right.offset(-12);
            makeTopOffSet(_container, 10);
            make.width.offset(10);
            make.height.offset(10);
        })
        closeImg.userInteractionEnabled = YES;
        ls_addTapGestureRecognizer(closeImg, {
            [self dismiss];
        })
        
        _close = [[UIImageView alloc] init];
        _close.image = [UIImage imageNamed:@"icon_closetopic"];
        _close.contentMode = UIViewContentModeCenter;
        [_close addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        [_container addSubview:_close];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.container);
            make.height.mas_equalTo(35);
        }];
        [_close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.label);
            make.right.equalTo(self.label).inset(10);
            make.width.height.mas_equalTo(30);
        }];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth, ScreenHeight*3/4 - 35 - 50 - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ColorClear;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:CommentListCell.class forCellReuseIdentifier:kCommentListCell];
        [_tableView registerClass:CommentListSmallCell.class forCellReuseIdentifier:kCommentListSamllCell];
        
        __weak __typeof(self) wself = self;
       _tableView.mj_footer   = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
           [wself getMoreData];
       }];
         _tableView.mj_footer.hidden = YES;
        
        [_container addSubview:_tableView];
        
        _textView = [CommentTextView new];
        _textView.delegate = self;

        [self getData];
    }
    return self;
}

#pragma  mark  - 请求数据
//主评论
-(void)getData{
    
    self.pageIndex = 0;
    
    [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:_awemeId forKey:@"video_id"];
    [dataDic setObject:@"0" forKey:@"root_id"];//0 表示只对视频的评论
    
    NSMutableDictionary *pageDic = @{}.mutableCopy;
    [pageDic setObject:@(_pageSize) forKey:@"size"];
    [pageDic setObject:@(self.pageIndex) forKey:@"index"];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:dataDic forKey:@"data"];
    [dic setObject:@"list" forKey:@"action"];
    [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];
    [dic setObject:pageDic forKey:@"paging"];
    
    [[HttpRequest sharedClient]postWithUrl:YXUserUserComment body:dic success:^(NSDictionary *response) {
        NSLog(@"%@",response);
        _data = [YXVideoCommentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
       [MBProgressHUD hideHUDForView:_tableView animated:YES];
        [self.tableView reloadData];
        if (_data.count < _pageSize) {
            _tableView.mj_footer.hidden = YES;
        }else{
            _tableView.mj_footer.hidden = NO;
        }
    } failure:^(NSError *error) {
        
    }];
}

//获取更多主评论
-(void)getMoreData{
    
    self.pageIndex++;
    
    [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:_awemeId forKey:@"video_id"];
    [dataDic setObject:@"0" forKey:@"root_id"];//0 表示只对视频的评论
    
    NSMutableDictionary *pageDic = @{}.mutableCopy;
    [pageDic setObject:@(_pageSize) forKey:@"size"];
    [pageDic setObject:@(self.pageIndex) forKey:@"index"];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:dataDic forKey:@"data"];
    [dic setObject:@"list" forKey:@"action"];
    [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];
    [dic setObject:pageDic forKey:@"paging"];
    NSLog(@"%@",dic);
    
    [[HttpRequest sharedClient]postWithUrl:YXUserUserComment body:dic success:^(NSDictionary *response) {
        NSLog(@"more%@",response);
        
        [MBProgressHUD hideHUDForView:_tableView animated:YES];
        
        NSArray *array = [YXVideoCommentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
       
        [_tableView.mj_footer endRefreshing];

        
        if (array.count==0) {
            
            m_ToastCenter(@"暂时没有更多了");
            _tableView.mj_footer.hidden = YES;
            
        }else{
            
            [self.data addObjectsFromArray:array];
              
            [self.tableView reloadData];
        }
       
        
    } failure:^(NSError *error) {
        
    }];
}

//子分支评论
-(void)getDataForRoot_id:(NSString *)root_id{
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:_awemeId forKey:@"video_id"];
    [dataDic setObject:root_id forKey:@"root_id"];
    
    NSMutableDictionary *pageDic = @{}.mutableCopy;
    [pageDic setObject:@(20) forKey:@"size"];
    [pageDic setObject:@"0" forKey:@"index"];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:dataDic forKey:@"data"];
    [dic setObject:@"list" forKey:@"action"];
    [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];
    [dic setObject:pageDic forKey:@"paging"];
   
    [[HttpRequest sharedClient]postWithUrl:YXUserUserComment body:dic success:^(NSDictionary *response) {
        NSLog(@"%@",response);
        NSArray *childArr = [YXVideoCommentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        self.willShowMoreCommentModel.childModelArr = (NSMutableArray *)childArr;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
// comment textView delegate
#pragma  mark  - 发送评论

-(void)onSendText:(NSString *)text {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    //评论视频时，这几个参数传 0；
    if (self.commentType == commentType_video) {
        
        [dataDic setObject:@"0" forKey:@"root_id"];
        [dataDic setObject:@"0" forKey:@"target_id"];
        [dataDic setObject:@"0" forKey:@"target_user_id"];
        [dataDic setObject:@"0" forKey:@"target_user_nick_name"];
        
    }else if(self.commentType == commentType_comment){
        
        [dataDic setObject:[self.selectedCommentModel.root_id isEqualToString:@"0"]?self.selectedCommentModel.ID:self.selectedCommentModel.root_id forKey:@"root_id"];
        [dataDic setObject:self.selectedCommentModel.ID forKey:@"target_id"];
        [dataDic setObject:self.selectedCommentModel.user_id forKey:@"target_user_id"];
        [dataDic setObject:self.selectedCommentModel.user_nick_name forKey:@"target_user_nick_name"];
    }

    [dataDic setObject:_awemeId forKey:@"video_id"];
    [dataDic setObject:m_UserDefaultObjectForKey(Account_User_ID) forKey:@"user_id"];
    [dataDic setObject:m_UserDefaultObjectForKey(Account_NickName) forKey:@"user_nick_name"];
    [dataDic setObject:text forKey:@"comment_content"];
    NSLog(@"%@",dataDic);
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:dataDic forKey:@"data"];
    [dic setObject:@"add" forKey:@"action"];
    [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];
  
    [[HttpRequest sharedClient]postWithUrl:YXUserUserComment body:dic success:^(NSDictionary *response) {
        NSLog(@"%@",response);
        m_ToastCenter(@"评论成功");
      
        //刷新界面
        [self reloadViewWithId:response[@"data"][@"id"] andDic:dataDic];
        
        self.commentType = commentType_video;
        self.textView.placeholderLabel.text = @"添加评论...";
        
    } failure:^(NSError *error) {
        
    }];
    
}

/// 刷新界面
/// @param ID 评论成功 后台返回的评论id
/// @param dataDic 上传的评论数据
-(void)reloadViewWithId:(NSString *)ID andDic:(NSMutableDictionary *)dataDic{
  
//    if (self.commentType==commentType_comment) {
//        return;//
//    }
    YXVideoCommentModel *comment = [YXVideoCommentModel mj_objectWithKeyValues:dataDic];
        comment.created_at = 0;
        comment.ID = ID;
        [UIView setAnimationsEnabled:NO];
    if (self.commentType==commentType_comment) {
       
          //直接网络请求并展示最新的回复内容，
        [self getDataForRoot_id:_selectedCommentModel.isFirstLevel?_selectedCommentModel.ID:_selectedCommentModel.root_id];

    }else if (self.commentType == commentType_video){
        //如果是评论视频,插入到一级数组
        [_data insertObject:comment atIndex:0];
    }
        
        [_tableView reloadData];
    //    [_tableView beginUpdates];
    //    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:<#(NSInteger)#> inSection:<#(NSInteger)#>]] withRowAnimation:UITableViewRowAnimationNone];
    //    [_tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    //    [_tableView endUpdates];
    //    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [UIView setAnimationsEnabled:YES];
}
// tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YXVideoCommentModel *model = _data[section];
    return model.childModelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXVideoCommentModel *modelSection = _data[indexPath.section];
    YXVideoCommentModel *modelRow = modelSection.childModelArr[indexPath.row];//获取二级评论模型
    return [CommentListSmallCell cellHeight:modelRow];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [CommentListCell cellHeight:_data[section]];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentListCell];
    cell.delegate = self;
    cell.indexPath = [NSIndexPath indexPathWithIndex:section];
    [cell initData:_data[section]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    YXVideoCommentModel *model = _data[section];
    return model.count_children==0||model.childModelArr.count!=0?0:30;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    YXVideoCommentModel *model = _data[section];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    footerView.backgroundColor = ColorWhite;
    if (model.count_children==0) {
        return footerView;
    }
    WeakSelf;
    ls_button(showMore, @"---展开更多回复", m_FontPF_Regular_WithSize(12), Color40, @"down", ColorWhite, 0, footerView, {
        make.left.offset(15+28+10);
        makeTopOffSet(footerView, 0);
        make.height.offset(30);
    }, {
        weakSelf.willShowMoreCommentModel = model;
        [weakSelf getDataForRoot_id:model.ID];
    })
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentListSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentListSamllCell];
    YXVideoCommentModel *modelSection = _data[indexPath.section];
    YXVideoCommentModel *modelRow = modelSection.childModelArr[indexPath.row];//获取二级评论模型
    [cell initData:modelRow];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    Comment *comment = _data[indexPath.row];
//    if(!comment.isTemp && [@"visitor" isEqualToString:comment.user_type] ) {
//        MenuPopView *menu = [[MenuPopView alloc] initWithTitles:@[@"删除"]];
//        __weak __typeof(self) wself = self;
//        menu.onAction = ^(NSInteger index) {
//            [wself deleteComment:comment];
//        };
//        [menu show];
//    }
}

//delete comment
//- (void)deleteComment:(Comment *)comment {
//    __weak __typeof(self) wself = self;
//    DeleteCommentRequest *request = [DeleteCommentRequest new];
//    request.cid = comment.cid;
//    request.udid = UDID;
//    [NetworkHelper deleteWithUrlPath:DeleteComentByIdPath request:request success:^(id data) {
//        NSInteger index = [wself.data indexOfObject:comment];
//        [wself.tableView beginUpdates];
//        [wself.data removeObjectAtIndex:index];
//        [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
//        [wself.tableView endUpdates];
//        [UIWindow showTips:@"评论删除成功"];
//    } failure:^(NSError *error) {
//        [UIWindow showTips:@"评论删除失败"];
//    }];
//}
#pragma  mark  回复某个评论 delegate
- (void)commentViewDidSelectedModel:(YXVideoCommentModel *)model isFirstLevel:(BOOL)isFirstLevel withIndexPath:(NSIndexPath *)indexPath{
    _selectedCommentModel = model;
    _selectedCommentModel.isFirstLevel = isFirstLevel;
    _willShowMoreCommentModel = _data[indexPath.section];
    self.commentType = commentType_comment;
    self.textView.placeholderLabel.text = [NSString stringWithFormat:@"回复：%@",model.user_nick_name];
    [self.textView.textView becomeFirstResponder];
}

//guesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"CommentListCell"]) {
        return NO;
    }else {
        return YES;
    }
}

- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
    point = [sender locationInView:_close];
    if([_close.layer containsPoint:point]) {
        [self dismiss];
    }
}

//update method
- (void)show {
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y - frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
    [self.textView show];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [self.textView dismiss];
                     }];
}

//load data
- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    [self.loadMore endLoading];
    [self.loadMore loadingFailed];
//    __weak __typeof(self) wself = self;
//    CommentListRequest *request = [CommentListRequest new];
//    request.page = pageIndex;
//    request.size = pageSize;
//    request.aweme_id = _awemeId;
//    [NetworkHelper getWithUrlPath:FindComentByPagePath request:request success:^(id data) {
//        CommentListResponse *response = [[CommentListResponse alloc] initWithDictionary:data error:nil];
//        NSArray<Comment *> *array = response.data;
//
//        wself.pageIndex++;
//
//        [UIView setAnimationsEnabled:NO];
//        [wself.tableView beginUpdates];
//        [wself.data addObjectsFromArray:array];
//        NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
//        for(NSInteger row = wself.data.count - array.count; row<wself.data.count; row++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//            [indexPaths addObject:indexPath];
//        }
//        [wself.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//        [wself.tableView endUpdates];
//        [UIView setAnimationsEnabled:YES];
//
//        [wself.loadMore endLoading];
//        if(!response.has_more) {
//            [wself.loadMore loadingAll];
//        }
//        wself.label.text = [NSString stringWithFormat:@"%ld条评论",(long)response.total_count];
//    } failure:^(NSError *error) {
//        [wself.loadMore loadingFailed];
//    }];
}

//UIScrollViewDelegate Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < 0) {
        self.frame = CGRectMake(0, -offsetY, self.frame.size.width, self.frame.size.height);
    }
    if (scrollView.isDragging && offsetY < -50) {
        [self dismiss];
    }
}

- (void)setTotalCommentNum:(NSString *)totalCommentNum{
    _totalCommentNum = totalCommentNum;
    self.label.text = [NSString stringWithFormat:@"%@条评论",totalCommentNum];
}
@end


#pragma comment tableview cell

#define MaxContentWidth     ScreenWidth - 55 - 35
//cell
@implementation CommentListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorClear;
        self.clipsToBounds = YES;
        _avatar = [[UIImageView alloc] init];
        _avatar.image = [UIImage imageNamed:@"img_find_default"];
        _avatar.clipsToBounds = YES;
        _avatar.layer.cornerRadius = 14;
        _avatar.backgroundColor = m_Color_gray(216);
        _avatar.layer.borderColor = KMainYellowColor.CGColor;
        _avatar.layer.borderWidth = 0.5;
        [self addSubview:_avatar];
        
        
        ls_button(like, @"", m_FontPF_Regular_WithSize(12), ColorWhite, @"likenoselected", ColorClear, 0, self, {
            make.top.right.equalTo(self).inset(15);
            make.width.height.mas_equalTo(20);
        }, {
            
        })
        _likeIcon = likeButton;
    
        _nickName = [[UILabel alloc] init];
        _nickName.numberOfLines = 1;
        _nickName.textColor = Color40;
        _nickName.font = SmallFont;
        [self addSubview:_nickName];
        
        _content = [[UILabel alloc] init];
        _content.numberOfLines = 0;
        _content.textColor = ColorBlack;
        _content.font = MediumFont;
        [self addSubview:_content];
        
        WeakSelf;
        ls_addTapGestureRecognizer(_content, {
           if ([weakSelf.delegate respondsToSelector:@selector(commentViewDidSelectedModel:isFirstLevel: withIndexPath:)]) {
                [self.delegate commentViewDidSelectedModel:weakSelf.model isFirstLevel:YES withIndexPath:self.indexPath];
            }
        })
        
        _date = [[UILabel alloc] init];
        _date.numberOfLines = 1;
        _date.textColor = m_Color_gray(156);
        _date.font = SmallFont;
        [self addSubview:_date];
        
        _likeNum = [[UILabel alloc] init];
        _likeNum.numberOfLines = 1;
        _likeNum.textColor = m_Color_gray(147);
        _likeNum.font = SmallFont;
        [self addSubview:_likeNum];
        
        _splitLine = [[UIView alloc] init];
        _splitLine.backgroundColor = ColorWhiteAlpha10;
        [self addSubview:_splitLine];
        
        [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).inset(15);
            make.width.height.mas_equalTo(28);
        }];
     
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self.avatar.mas_right).offset(10);
            make.right.equalTo(self.likeIcon.mas_left).inset(25);
        }];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickName.mas_bottom).offset(5);
            make.left.equalTo(self.nickName);
            make.width.offset(MaxContentWidth);
        }];
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.content.mas_bottom).offset(5);
            make.left.right.equalTo(self.nickName);
        }];
        [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.likeIcon);
            make.top.equalTo(self.likeIcon.mas_bottom).offset(5);
        }];
        [_splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.date);
            make.right.equalTo(self.likeIcon);
            make.top.equalTo(self.date.mas_bottom).offset(9.5);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    return self;
}

-(void)initData:(YXVideoCommentModel *)comment {
    
    _model = comment;
    
    NSURL *avatarUrl;
   avatarUrl = [NSURL URLWithString:@"https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3173584241,3533290860&fm=26&gp=0.jpg"];
   _nickName.text = comment.user_nick_name;
    
    __weak __typeof(self) wself = self;
    [_avatar sd_setImageWithURL:avatarUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
//        image = [image drawCircleImage];
         
        wself.avatar.image = image;
    }];
   
    _content.text = comment.comment_content;
    _date.text = comment.created_at==0?@"刚刚":[NSDate formatTime:comment.created_at];
    _likeNum.text = [NSString formatCount:comment.count_like];
    
}

+(CGFloat)cellHeight:(YXVideoCommentModel *)comment {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:comment.comment_content];
    [attributedString addAttribute:NSFontAttributeName value:MediumFont range:NSMakeRange(0, attributedString.length)];
    CGSize size = [attributedString multiLineSize:MaxContentWidth];
    return size.height + 30 + SmallFont.lineHeight * 2;
}
@end

#pragma CommentListSmallCell tableview cell
#define  leftM  (15+28+10)
#define MaxContentSmallWidth     ScreenWidth - (leftM) - 80
//cell
@implementation CommentListSmallCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorClear;
        self.clipsToBounds = YES;
        
        ls_view(container, ColorClear, self, {
            make.left.offset(leftM);
            makeTopOffSet(self, 0);
            make.width.offset(ScreenWidth-leftM);
            make.bottom.offset(0);
        })
        self.containerView = containerView;
        
        _avatar = [[UIImageView alloc] init];
        _avatar.image = [UIImage imageNamed:@"img_find_default"];
        _avatar.clipsToBounds = YES;
        _avatar.layer.cornerRadius = 10;
        _avatar.layer.borderColor = KMainYellowColor.CGColor;
        _avatar.layer.borderWidth = 0.5;
        _avatar.backgroundColor = m_Color_RGB(216, 216, 216);
        [self.containerView addSubview:_avatar];
        
        ls_button(like, @"", m_FontPF_Regular_WithSize(12), ColorWhite, @"likenoselected", ColorClear, 0, self.containerView, {
            make.top.right.equalTo(self).inset(15);
            make.width.height.mas_equalTo(20);
        }, {
            
        })
        _likeIcon = likeButton;
        
        _nickName = [[UILabel alloc] init];
        _nickName.numberOfLines = 1;
        _nickName.textColor = Color40;
        _nickName.font = SmallFont;
        [self.containerView addSubview:_nickName];
        
        _content = [[UILabel alloc] init];
        _content.numberOfLines = 0;
        _content.textColor = ColorBlack;
        _content.font = MediumFont;
        [self.containerView addSubview:_content];
        
        WeakSelf;
       ls_addTapGestureRecognizer(_content, {
          if ([weakSelf.delegate respondsToSelector:@selector(commentViewDidSelectedModel:isFirstLevel:withIndexPath:)]) {
               [self.delegate commentViewDidSelectedModel:weakSelf.model isFirstLevel:NO withIndexPath:self.indexPath];
           }
       })
        
        _date = [[UILabel alloc] init];
        _date.numberOfLines = 1;
        _date.textColor = m_Color_gray(156);
        _date.font = SmallFont;
        [self.containerView addSubview:_date];
        
        _likeNum = [[UILabel alloc] init];
        _likeNum.numberOfLines = 1;
        _likeNum.textColor = m_Color_gray(147);
        _likeNum.font = SmallFont;
        [self.containerView addSubview:_likeNum];
        
        _splitLine = [[UIView alloc] init];
        _splitLine.backgroundColor = ColorWhiteAlpha10;
        [self.containerView addSubview:_splitLine];
        
        [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.containerView).inset(15);
            make.width.height.mas_equalTo(20);
        }];
        [_likeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.containerView).inset(15);
            make.width.height.mas_equalTo(20);
        }];
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView).offset(10);
            make.left.equalTo(self.avatar.mas_right).offset(10);
            make.right.equalTo(self.likeIcon.mas_left).inset(25);
        }];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickName.mas_bottom).offset(5);
            make.left.equalTo(self.nickName);
            make.width.offset(MaxContentSmallWidth);
        }];
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.content.mas_bottom).offset(5);
            make.left.right.equalTo(self.nickName);
        }];
        [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.likeIcon);
            make.top.equalTo(self.likeIcon.mas_bottom).offset(5);
        }];
        [_splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.date);
            make.right.equalTo(self.likeIcon);
            make.top.equalTo(self.date.mas_bottom).offset(9.5);
            make.bottom.equalTo(self.containerView);
            make.height.mas_equalTo(0.5);
        }];
    }
    
//    ls_view(bottomLine, m_Color_gray(200), self, {
//        make.left.offset(KMargin);
//        makeBottomOffSet(self, 0);
//        make.right.offset(0);
//        make.height.offset(0.5);
//    })
    
    return self;
}

-(void)initData:(YXVideoCommentModel *)comment {
    
    _model = comment;
    
    NSURL *avatarUrl;
    avatarUrl = [NSURL URLWithString:@"https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3173584241,3533290860&fm=26&gp=0.jpg"];
    _nickName.text = comment.user_nick_name;
                
    __weak __typeof(self) wself = self;
    [_avatar sd_setImageWithURL:avatarUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
//        image = [image drawCircleImage];
         
        wself.avatar.image = image;
    }];
   
    _content.text = [NSString stringWithFormat:@"回复 %@: %@",comment.target_user_nick_name,comment.comment_content];
    [_content setAttributeTextWithString:_content.text range:NSMakeRange(3, comment.target_user_nick_name.length+1) WithColour:[UIColor lightGrayColor]];
    _date.text = comment.created_at==0?@"刚刚":[NSDate formatTime:comment.created_at];
    _likeNum.text = [NSString formatCount:comment.count_like];
    
}

+(CGFloat)cellHeight:(YXVideoCommentModel *)comment {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:comment.comment_content];
    [attributedString addAttribute:NSFontAttributeName value:MediumFont range:NSMakeRange(0, attributedString.length)];
    CGSize size = [attributedString multiLineSize:MaxContentSmallWidth];
    return size.height + 30 + SmallFont.lineHeight * 2;
}
@end


#pragma TextView

static const CGFloat kCommentTextViewLeftInset               = 15;
static const CGFloat kCommentTextViewRightInset              = 60;
static const CGFloat kCommentTextViewTopBottomInset          = 15;

@interface CommentTextView ()<UITextViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat            textHeight;
@property (nonatomic, assign) CGFloat            keyboardHeight;

@property (nonatomic, strong) UIImageView        *atImageView;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@end

@implementation CommentTextView
- (instancetype)init {
    self = [super init];
    if(self) {
        self.frame = ScreenFrame;
        self.backgroundColor = ColorClear;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50 - SafeAreaBottomHeight, ScreenWidth, 50 + SafeAreaBottomHeight)];
        _container.backgroundColor = ColorWhite;
        [self addSubview:_container];
        
        _keyboardHeight = SafeAreaBottomHeight;
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _textView.backgroundColor = ColorWhite;
        
        _textView.clipsToBounds = NO;
        _textView.textColor = ColorWhite;
        _textView.font = BigFont;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.scrollEnabled = NO;
        _textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        _textView.textContainerInset = UIEdgeInsetsMake(kCommentTextViewTopBottomInset, kCommentTextViewLeftInset, kCommentTextViewTopBottomInset, kCommentTextViewRightInset);
        _textView.textContainer.lineFragmentPadding = 0;
        _textHeight = ceilf(_textView.font.lineHeight);
        
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.text = @"添加评论...";
        _placeholderLabel.textColor = Color40;
        _placeholderLabel.font = MediumFont;
        _placeholderLabel.frame = CGRectMake(kCommentTextViewLeftInset, 0, ScreenWidth - kCommentTextViewLeftInset - kCommentTextViewRightInset, 50);
        [_textView addSubview:_placeholderLabel];
        [_container addSubview:_textView];
        
//        _atImageView = [[UIImageView alloc] init];
//        _atImageView.contentMode = UIViewContentModeCenter;
//        _atImageView.image = [UIImage imageNamed:@"iconWhiteaBefore"];
//        [_textView addSubview:_atImageView];
      
        
        _textView.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _atImageView.frame = CGRectMake(ScreenWidth - 50, 0, 50, 50);
    
//    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
//    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
//    [shape setPath:rounded.CGPath];
//    _container.layer.mask = shape;
    
    [self updateTextViewFrame];
}


- (void)updateTextViewFrame {
    CGFloat textViewHeight = _keyboardHeight > SafeAreaBottomHeight ? _textHeight + 2*kCommentTextViewTopBottomInset : ceilf(_textView.font.lineHeight) + 2*kCommentTextViewTopBottomInset;
    _textView.frame = CGRectMake(0, 0, ScreenWidth, textViewHeight);
    _container.frame = CGRectMake(0, ScreenHeight - _keyboardHeight - textViewHeight, ScreenWidth, textViewHeight + _keyboardHeight);
}

//keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification {
    _keyboardHeight = [notification keyBoardHeight];
    [self updateTextViewFrame];
    _atImageView.image = [UIImage imageNamed:@"iconBlackaBefore"];
    _container.backgroundColor = ColorWhite;
    _textView.textColor = ColorBlack;
    self.backgroundColor = ColorBlackAlpha60;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardHeight = SafeAreaBottomHeight;
    [self updateTextViewFrame];
    _atImageView.image = [UIImage imageNamed:@"iconWhiteaBefore"];
    _container.backgroundColor = ColorWhite;
    _textView.textColor = Color40;
    self.backgroundColor = ColorClear;
}

//textView delegate
-(void)textViewDidChange:(UITextView *)textView {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    
    if(!textView.hasText) {
        [_placeholderLabel setHidden:NO];
        _textHeight = ceilf(_textView.font.lineHeight);
    }else {
        [_placeholderLabel setHidden:YES];
        _textHeight = [attributedText multiLineSize:ScreenWidth - kCommentTextViewLeftInset - kCommentTextViewRightInset].height;
    }
    [self updateTextViewFrame];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        if(_delegate) {
            [_delegate onSendText:textView.text];
            [_placeholderLabel setHidden:NO];
            textView.text = @"";
            _textHeight = ceilf(textView.font.lineHeight);
            [textView resignFirstResponder];
        }
        return NO;
    }
    return YES;
}

//handle guesture tap
- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_textView];
    if(![_textView.layer containsPoint:point]) {
        [_textView resignFirstResponder];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        if(hitView.backgroundColor == ColorClear) {
            return nil;
        }
    }
    return hitView;
}

//update method
- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

