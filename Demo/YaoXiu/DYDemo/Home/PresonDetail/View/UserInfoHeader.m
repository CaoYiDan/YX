//
//  UserInfoHeader.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "UserInfoHeader.h"
#import "YXUserModel.h"
#import "YXFansAndFllowSVC.h"
#import "YXFollowSListVC.h"

static const NSTimeInterval kAnimationDefaultDuration = 0.25;

@interface UserInfoHeader ()

@property (nonatomic, strong) UIView                  *containerView;
@property (nonatomic, copy) NSArray<NSString *>       *constellations;

@end

@implementation UserInfoHeader
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        _isFollowed = NO;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    [self initAvatarBackground];
    
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_containerView];
    
    [self initAvatar];
    [self initActionsView];
    [self initInfoView];
    [self initBottomView];
}

- (void) initAvatarBackground {
    _topBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50 + SafeAreaTopHeight)];
    _topBackground.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_topBackground];
    
    _bottomBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35 + SafeAreaTopHeight, ScreenWidth, self.bounds.size.height - (35 + SafeAreaTopHeight))];
    _bottomBackground.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_bottomBackground];
    
//    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//    visualEffectView.frame = _bottomBackground.bounds;
//    visualEffectView.alpha = 1;
//    [_bottomBackground addSubview:visualEffectView];
    _bottomBackground.backgroundColor = ColorBlack;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [self createBezierPath].CGPath;
    _bottomBackground.layer.mask = maskLayer;
}

-(UIBezierPath *)createBezierPath {
    int avatarRadius = 54;
    int topOffset = 16;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, topOffset)];
    [bezierPath addLineToPoint:CGPointMake(25, topOffset)];
    [bezierPath addArcWithCenter:CGPointMake(25 + avatarRadius * cos(M_PI/4), avatarRadius * sin(M_PI/4) + topOffset) radius:avatarRadius startAngle:(M_PI * 5)/4 endAngle:(M_PI * 7)/4 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(25 + avatarRadius * cos(M_PI/4), topOffset)];
    [bezierPath addLineToPoint:CGPointMake(ScreenWidth, topOffset)];
    [bezierPath addLineToPoint:CGPointMake(ScreenWidth, self.bounds.size.height - (50 + SafeAreaTopHeight) + topOffset - 1)];
    [bezierPath addLineToPoint:CGPointMake(0, self.bounds.size.height - (50 + SafeAreaTopHeight) + topOffset - 1)];
    [bezierPath closePath];
    return bezierPath;
}

- (void) initAvatar {
    int avatarRadius = 48;
    _avatar = [[UIImageView alloc] init];
    _avatar.image = [UIImage imageNamed:@"img_find_default"];
    _avatar.userInteractionEnabled = YES;
    _avatar.tag = UserInfoHeaderAvatarTag;
    _avatar.layer.borderColor = KMainYellowColor.CGColor;
    _avatar.layer.cornerRadius = avatarRadius;
    _avatar.layer.borderWidth = 2;
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)]];
    [_containerView addSubview:_avatar];
    
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40 + SafeAreaTopHeight);
        make.left.equalTo(self).offset(15);
        make.width.height.mas_equalTo(avatarRadius*2);
    }];
}

- (void) initActionsView {
//    _settingIcon = [[UIImageView alloc] init];
//    _settingIcon.image = [UIImage imageNamed:@"icon_titlebar_whitemore"];
//    _settingIcon.contentMode = UIViewContentModeCenter;
//    _settingIcon.layer.backgroundColor = ColorWhiteAlpha20.CGColor;
//    _settingIcon.layer.cornerRadius = 2;
//    _settingIcon.tag = UserInfoHeaderSettingTag;
//    _settingIcon.userInteractionEnabled = YES;
//    [_settingIcon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapAction:)]];
//    [_containerView addSubview:_settingIcon];
//    [_settingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.avatar);
//        make.right.equalTo(self).inset(15);
//        make.width.height.mas_equalTo(40);
//    }];
    
   
    _sendMessage = [[UILabel alloc] init];
    _sendMessage.text = @"私信";
    _sendMessage.textColor = ColorWhiteAlpha60;
    _sendMessage.textAlignment = NSTextAlignmentCenter;
    _sendMessage.font = MediumFont;
    _sendMessage.hidden = !_isFollowed;
    _sendMessage.layer.backgroundColor = ColorWhiteAlpha20.CGColor;
    _sendMessage.layer.cornerRadius = 2;
    _sendMessage.tag = UserInfoHeaderSendTag;
    _sendMessage.userInteractionEnabled = YES;
    [_sendMessage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapAction:)]];
    [_containerView addSubview:_sendMessage];
    [_sendMessage mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.avatar);
       make.right.equalTo(self).inset(15);
       make.height.mas_equalTo(40);
       make.width.offset(70);
    }];
    
    _focusIcon = [[UIImageView alloc] init];
       _focusIcon.contentMode = UIViewContentModeCenter;
       _focusIcon.userInteractionEnabled = YES;
       _focusIcon.clipsToBounds = YES;
       _focusIcon.hidden = !_isFollowed;
       _focusIcon.layer.backgroundColor = ColorWhiteAlpha20.CGColor;
       _focusIcon.layer.cornerRadius = 2;
       _focusIcon.tag = UserInfoHeaderFocusCancelTag;
       ls_label(cancleFollow, @"取消关注", m_Color_RGB(250, 212, 72), m_FontPF_Medium_WithSize(14),ColorClear, NSTextAlignmentCenter, _focusIcon, {
        make.edges.offset(0);
       })
    
       [_focusIcon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapAction:)]];
       [_containerView addSubview:_focusIcon];
       [_focusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.avatar);
           make.right.equalTo(self.sendMessage.mas_left).inset(5);
           make.height.mas_equalTo(40);
           make.width.mas_equalTo(165);
          
       }];
       
    
    
    _focusButton = [[UIButton alloc] init];
    [_focusButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
    [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
    [_focusButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    _focusButton.titleLabel.font = MediumFont;
    _focusButton.hidden = _isFollowed;
    _focusButton.clipsToBounds = YES;
    [_focusButton setImage:[UIImage imageNamed:@"icon_personal_add_little"] forState:UIControlStateNormal];
    [_focusButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
    _focusButton.layer.backgroundColor = KMainYellowColor.CGColor;
    _focusButton.layer.cornerRadius = 2;
    _focusButton.tag = UserInfoHeaderFocusTag;
    [_focusButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapAction:)]];
    [_containerView addSubview:_focusButton];
    [_focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatar);
        make.right.equalTo(self).inset(15);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(177);
    }];
}

- (void)initInfoView {
    _nickName = [[UILabel alloc] init];
    _nickName.text = @"name";
    _nickName.textColor = ColorWhite;
    _nickName.font = SuperBigBoldFont;
    [_containerView addSubview:_nickName];
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(20);
        make.left.equalTo(self.avatar);
        make.right.equalTo(self.settingIcon);
    }];
    
    _douyinNum = [[UILabel alloc] init];
    _douyinNum.text = @"吆秀号：";
    _douyinNum.textColor = ColorWhite;
    _douyinNum.font = SmallFont;
    [_containerView addSubview:_douyinNum];
    [_douyinNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickName.mas_bottom).offset(3);
        make.left.right.equalTo(self.nickName);
    }];
    
    UIImageView *weiboArrow = [[UIImageView alloc] init];
    weiboArrow.image = [UIImage imageNamed:@"icon_arrow"];
    [_containerView addSubview:weiboArrow];
    [weiboArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self.douyinNum);
        make.width.height.mas_equalTo(12);
    }];
    
    
    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = ColorWhiteAlpha20;
    [_containerView addSubview:splitView];
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.douyinNum.mas_bottom).offset(10);
        make.left.right.equalTo(self.nickName);
        make.height.mas_equalTo(0.5);
    }];
    
    _brief = [[UILabel alloc] init];
    _brief.text = @"本宝宝暂时还没想到个性的签名";
    _brief.textColor = ColorWhiteAlpha60;
    _brief.font = SmallFont;
    _brief.numberOfLines = 0;
    [_containerView addSubview:_brief];
    [_brief mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView.mas_bottom).offset(10);
        make.left.right.equalTo(self.nickName);
    }];
    
    _genderIcon = [[UIImageView alloc] init];
    _genderIcon.image = [UIImage imageNamed:@"iconUserProfileGirl"];
    _genderIcon.layer.backgroundColor = ColorWhiteAlpha20.CGColor;
    _genderIcon.layer.cornerRadius = 9;
    _genderIcon.contentMode = UIViewContentModeCenter;
    [_containerView addSubview:_genderIcon];
    [_genderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickName);
        make.top.equalTo(self.brief.mas_bottom).offset(8);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(22);
    }];
    
    _city = [[UITextView alloc] init];
    _city.text = @"上海";
    _city.textColor = ColorWhite;
    _city.font = SuperSmallFont;
    _city.scrollEnabled = NO;
    _city.editable = NO;
    _city.textContainerInset = UIEdgeInsetsMake(3, 8, 3, 8);
    _city.textContainer.lineFragmentPadding = 0;
    
    _city.layer.backgroundColor = ColorWhiteAlpha20.CGColor;
    _city.layer.cornerRadius = 9;
    [_city sizeToFit];
    [_containerView addSubview:_city];
    [_city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.genderIcon.mas_right).offset(5);
        make.top.height.equalTo(self.genderIcon);
    }];
    
    _likeNum = [[UILabel alloc] init];
    _likeNum.text = @"0获赞";
    _likeNum.textColor = ColorWhite;
    _likeNum.font = BigBoldFont;
    [_containerView addSubview:_likeNum];
    [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.genderIcon.mas_bottom).offset(15);
        make.left.equalTo(self.avatar);
    }];
    
    _followNum = [[UILabel alloc] init];
    _followNum.text = @"0关注";
    _followNum.textColor = ColorWhite;
    _followNum.font = BigBoldFont;
    [_containerView addSubview:_followNum];
    [_followNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeNum);
        make.left.equalTo(self.likeNum.mas_right).offset(30);
    }];
    
    ls_addTapGestureRecognizer(_followNum, {
        YXFansAndFllowSVC *vc = [[YXFansAndFllowSVC alloc]init];
        GKDYNavigationController *nav = [[GKDYNavigationController alloc]initWithRootViewController:vc];
        [[NSObject getCurrentVC] presentViewController:nav animated:YES completion:nil];
    })
    
    _followedNum = [[UILabel alloc] init];
    _followedNum.text = @"0粉丝";
    _followedNum.textColor = ColorWhite;
    _followedNum.font = BigBoldFont;
    [_containerView addSubview:_followedNum];
    [_followedNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeNum);
        make.left.equalTo(self.followNum.mas_right).offset(30);
    }];
    
    ls_addTapGestureRecognizer(_followedNum, {
        YXFansAndFllowSVC *vc = [[YXFansAndFllowSVC alloc]init];
        GKDYNavigationController *nav = [[GKDYNavigationController alloc]initWithRootViewController:vc];
        [[NSObject getCurrentVC] presentViewController:nav animated:YES completion:nil];
    })

   
     [_topBackground sd_setImageWithURL:[NSURL URLWithString:@"http://pb3.pstatp.com/obj/dbc1001cd29ccc479f7f"] completed:nil];
}

-(void)initBottomView{
    
    if (self.headerState == 0) {
        
        CGFloat leftMargin = 15;
        CGFloat bottomViewWid = ScreenWidth-leftMargin*2;
        
       //bottomBaseView
       ls_view(bottomBase,m_Color_gray(57), _containerView, {
                   make.left.offset(leftMargin);
                   makeBottomOffSet(_containerView, -10);
                   make.width.offset(bottomViewWid);
                   make.height.offset(50);
               })
        ls_cornerRadius(bottomBaseView, 3.5);

        //我的资产
        ls_button(mymoney,@"  我的资产", m_FontPF_Medium_WithSize(14), m_Color_gray(254), @"mymoney", ColorClear, 0, bottomBaseView, {
            make.left.offset(0);
            make.centerY.offset(0);
            make.height.offset(30);
            make.width.offset(bottomViewWid/2);
        }, {
            
        })
        
        //我的订单
        ls_button(myorder,@"  我的订单", m_FontPF_Medium_WithSize(14), m_Color_gray(254), @"myorder", ColorClear, 0, bottomBaseView, {
            make.left.offset(bottomViewWid/2);
            make.centerY.offset(0);
            make.height.offset(30);
            make.width.offset(bottomViewWid/2);
        }, {
            
        })
       
    }else if(self.headerState == YXHeaderMySelf){
        
        //查看他人
        ls_button(shopDetail,@"  商家详情", m_FontPF_Medium_WithSize(14), KMainYellowColor, @"shopdetail", ColorClear, 0, _containerView, {
                   make.left.offset(KMargin);
                   make.bottom.offset(-10);
                   make.height.offset(30);
               }, {
                   
               })
        
        ls_imageView(arrow, @"arrow", _containerView, {
                   make.right.offset(-KMargin);
                    make.centerY.equalTo(shopDetailButton).offset(0);
                   make.width.offset(7.5);
                   make.height.offset(12);
               })
        
        //添加点击事件
        ls_view(tap, ColorClear, _containerView, {
            make.left.offset(0);
            makeTopOffSet(shopDetailButton, 0);
            make.width.offset(ScreenWidth);
            make.height.offset(30);
        })
        
        ls_addTapGestureRecognizer(tapView, {
            NSLog(@"进入商家");
        })
    }
}

- (void)initData:(YXUserModel *)user {
    
    _userModel = user;
    
    if (user.status_followed) {
        self.isFollowed = !user.status_followed ;
           [self startFocusAnimation];
    }
   
//    __weak __typeof(self) wself = self;
//    [_avatar setImageWithURL:[NSURL URLWithString:user.avatar_medium.url_list.firstObject] completedBlock:^(UIImage *image, NSError *error) {
//        [wself.bottomBackground setImage:image];
//        [wself.avatar setImage:[image drawCircleImage]];
//    }];
    //新增的背景数据写为指定路径
    [_topBackground sd_setImageWithURL:[NSURL URLWithString:@"http://pb3.pstatp.com/obj/dbc1001cd29ccc479f7f"] completed:nil];
    [_nickName setText:user.user_name];
    [_douyinNum setText:[NSString stringWithFormat:@"抖音号:%@", user.user_yx_no]];
    if(![user.user_introduction isEqual: @""]) {
        [_brief setText:user.user_introduction];
    }
    [_genderIcon setImage:[UIImage imageNamed:user.user_sex == 0 ? @"iconUserProfileBoy" : @"iconUserProfileGirl"]];
   
    [_likeNum setAttributedStringWithFirstString:[NSString stringWithFormat:@"%@ ",user.count_belike] withFirstColour:m_Color_gray(254) withFirstFont:m_FontPF_Medium_WithSize(15) withSecondString:@"获赞" withSecondColour:m_Color_gray(144) withSecondFont:m_FontPF_Regular_WithSize(14)];
  
    [_followedNum setAttributedStringWithFirstString:[NSString stringWithFormat:@"%@ ",user.count_fans] withFirstColour:m_Color_gray(254) withFirstFont:m_FontPF_Medium_WithSize(15) withSecondString:@"关注" withSecondColour:m_Color_gray(144) withSecondFont:m_FontPF_Regular_WithSize(14)];
  
    [_followNum setAttributedStringWithFirstString:[NSString stringWithFormat:@"%@ ",user.count_fans] withFirstColour:m_Color_gray(254) withFirstFont:m_FontPF_Medium_WithSize(15) withSecondString:@"粉丝" withSecondColour:m_Color_gray(144) withSecondFont:m_FontPF_Regular_WithSize(14)];
 
}

- (void)onTapAction:(UITapGestureRecognizer *)sender {
    if(self.delegate) {
        [self.delegate onUserActionTap:sender.view.tag];
    }
}

#pragma update position when over scroll

- (void)overScrollAction:(CGFloat) offsetY {
    CGFloat scaleRatio = fabs(offsetY)/370.0f;
    CGFloat overScaleHeight = (370.0f * scaleRatio)/2;
    _topBackground.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scaleRatio + 1.0f, scaleRatio + 1.0f), CGAffineTransformMakeTranslation(0, -overScaleHeight));
}

- (void)scrollToTopAction:(CGFloat) offsetY {
    CGFloat alphaRatio = offsetY/(370.0f - 44 - StatusBarHeight);
    _containerView.alpha = 1.0f - alphaRatio;
}

#pragma animation

- (void)startFocusAnimation {
    
    [self showSendMessageAnimation];
    [self showFollowedAnimation];
    [self showUnFollowedAnimation];
    
}

-(void)requestChangeStatus{
    
    if (_isFollowed) {
           
         NSMutableDictionary *dataDic = @{}.mutableCopy;
         [dataDic setObject:m_UserDefaultObjectForKey(Account_User_ID) forKey:@"user_id"];
         [dataDic setObject:self.userModel.ID forKey:@"user_id_target"];
         
         NSMutableDictionary *dic = @{}.mutableCopy;
         [dic setObject:dataDic forKey:@"data"];
         [dic setObject: @"del" forKey:@"action"];
         [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];

         [[HttpRequest sharedClient]postWithUrl:YXUserFollow body:dic success:^(NSDictionary *response) {
          
         } failure:^(NSError *error) {
             
         }];
           
       }else{
           
          NSMutableDictionary *dataDic = @{}.mutableCopy;
           [dataDic setObject:m_UserDefaultObjectForKey(Account_User_ID) forKey:@"user_id"];
           [dataDic setObject:self.userModel.ID forKey:@"user_id_target"];
           
           NSMutableDictionary *dic = @{}.mutableCopy;
           [dic setObject:dataDic forKey:@"data"];
           [dic setObject: @"add" forKey:@"action"];
           [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];

           [[HttpRequest sharedClient]postWithUrl:YXUserFollow body:dic success:^(NSDictionary *response) {
            
           } failure:^(NSError *error) {
               
           }];
           
       }
}

- (void)showSendMessageAnimation {
    if(!_isFollowed) {
        [_focusIcon setHidden:NO];
        [_sendMessage setHidden:NO];
    }
    if(_isFollowed) {
        [_focusButton setHidden:NO];
    }
    
    _focusButton.userInteractionEnabled = NO;
    _focusIcon.userInteractionEnabled = NO;
    if(_isFollowed) {
        [UIView animateWithDuration:kAnimationDefaultDuration animations:^{
            self.sendMessage.alpha = 0;
            CGRect frame = self.sendMessage.frame;
            frame.origin.x = frame.origin.x - 35;
            [self.sendMessage setFrame:frame];
        } completion:^(BOOL finished) {
            
            [self.focusIcon setHidden:self.isFollowed];
            [self.focusButton setHidden:!self.isFollowed];
            self.isFollowed = !self.isFollowed;
            
            CGRect frame = self.sendMessage.frame;
            frame.origin.x = frame.origin.x + 35;
            [self.sendMessage setFrame:frame];
            
            self.focusButton.userInteractionEnabled = YES;
            self.focusIcon.userInteractionEnabled = YES;
        }];
    }else {
        CGRect frame = _sendMessage.frame;
        frame.origin.x = frame.origin.x - 35;
        [_sendMessage setFrame:frame];
        [UIView animateWithDuration:kAnimationDefaultDuration animations:^{
            self.sendMessage.alpha = 1;
            CGRect frame = self.sendMessage.frame;
            frame.origin.x = frame.origin.x + 35;
            [self.sendMessage setFrame:frame];
        } completion:^(BOOL finished) {
            [self.focusIcon setHidden:self.isFollowed];
            [self.focusButton setHidden:!self.isFollowed];
            self.isFollowed = !self.isFollowed;
            
            self.focusButton.userInteractionEnabled = YES;
            self.focusIcon.userInteractionEnabled = YES;
        }];
    }
}

- (void)showFollowedAnimation {
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.duration = kAnimationDefaultDuration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    CALayer *layer = _focusButton.layer;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0 , _focusButton.frame.size.width, _focusButton.frame.size.height )] CGPath];
    layer.mask = maskLayer;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    if (_isFollowed){
        positionAnimation.fromValue = @(layer.frame.origin.x + layer.frame.size.width);
        positionAnimation.toValue = @(layer.frame.origin.x + layer.frame.size.width*0.5);
    }else {
        positionAnimation.fromValue = @(layer.frame.origin.x + layer.frame.size.width*0.5);
        positionAnimation.toValue = @(layer.frame.origin.x + layer.frame.size.width);
    }
    
    CABasicAnimation *sizeAnimation = [CABasicAnimation animation];
    sizeAnimation.keyPath = @"bounds.size.width";
    if (_isFollowed){
        sizeAnimation.fromValue = @(0);
        sizeAnimation.toValue = @(layer.frame.size.width);
    }else {
        sizeAnimation.fromValue = @(layer.frame.size.width);
        sizeAnimation.toValue = @(0);
    }
    
    [animationGroup setAnimations:@[positionAnimation, sizeAnimation]];
    [layer addAnimation:animationGroup forKey:nil];
}

- (void)showUnFollowedAnimation {
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.duration = kAnimationDefaultDuration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    CALayer *layer = _focusIcon.layer;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0 , _focusIcon.frame.size.width, _focusIcon.frame.size.height )] CGPath];
    layer.mask = maskLayer;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    if (_isFollowed){
        positionAnimation.fromValue = @(layer.frame.origin.x + layer.frame.size.width*0.5);
        positionAnimation.toValue = @(layer.frame.origin.x - layer.frame.size.width);
    }else {
        positionAnimation.fromValue = @(layer.frame.origin.x - layer.frame.size.width);
        positionAnimation.toValue = @(layer.frame.origin.x + layer.frame.size.width*0.5);
    }
    
    CABasicAnimation *sizeAnimation = [CABasicAnimation animation];
    sizeAnimation.keyPath = @"bounds.size.width";
    if (_isFollowed){
        sizeAnimation.fromValue = @(layer.frame.size.width);
        sizeAnimation.toValue = @(0);
    }else {
        sizeAnimation.fromValue = @(0);
        sizeAnimation.toValue = @(layer.frame.size.width);
    }
    
    [animationGroup setAnimations:@[positionAnimation, sizeAnimation]];
    [layer addAnimation:animationGroup forKey:nil];
}

@end
