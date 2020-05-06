
//wekself 防止死循环
#define WeakSelf __weak typeof(self) weakSelf = self;

//imageView
#define ls_imageView(iconName,imgName,superView,masoryBlock)  UIImageView *iconName##Img = [[UIImageView alloc]init];iconName##Img.clipsToBounds = YES;[superView addSubview:iconName##Img];iconName##Img.image = [UIImage imageNamed:imgName];[superView addSubview:iconName##Img];iconName##Img.contentMode = UIViewContentModeScaleAspectFill,[iconName##Img mas_makeConstraints:^(MASConstraintMaker *make) masoryBlock];

//label
#define ls_label(labelName,tex,text_Color,fon,bgColor,aligment,superView,masoryBlock)   UILabel * labelName##Label = [[UILabel alloc]init];labelName##Label.text = tex;labelName##Label.textColor = text_Color;labelName##Label.backgroundColor = bgColor,labelName##Label.font = fon;labelName##Label.textAlignment = aligment;[superView addSubview:labelName##Label];[labelName##Label mas_makeConstraints:^(MASConstraintMaker *make) masoryBlock];

//buttton
#define ls_button(btnName,title,fon,titleColor,imgName,bgColor,border,superView,masoryBlock,RACBlock) UIButton * btnName##Button = [UIButton buttonWithType:UIButtonTypeCustom];btnName##Button.titleLabel.font=fon;[btnName##Button setTitle:title forState:UIControlStateNormal];[btnName##Button setTitleColor:titleColor forState:UIControlStateNormal];[btnName##Button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal]; btnName##Button.layer.cornerRadius = border;btnName##Button.clipsToBounds = YES;btnName##Button.backgroundColor = bgColor;[superView addSubview:btnName##Button];[btnName##Button mas_makeConstraints:^(MASConstraintMaker *make) masoryBlock]; [[btnName##Button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) RACBlock];

//cornerRadius
#define  ls_cornerRadius(view,value) view.layer.cornerRadius = value;\
view.clipsToBounds = YES;

//view
#define ls_view(viewName,bgColor,containerView,masoryBlock) UIView *viewName##View = [[UIView alloc]init];viewName##View.backgroundColor = bgColor;[containerView addSubview:viewName##View];[viewName##View mas_makeConstraints:^(MASConstraintMaker *make)masoryBlock];

//给普通控件添加tap手势
#define ls_addTapGestureRecognizer(view,tapActionBlock)  {view.userInteractionEnabled = YES;UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];\
[[tap rac_gestureSignal] subscribeNext:^(id x) tapActionBlock];\
[view addGestureRecognizer:tap];}

//make.top.equalTo(view).offset(x)
#define makeTopOffSet(view,x) make.top.equalTo(view).offset(x);
//make.bottom.equalTo(view).offset(x)
#define makeBottomOffSet(view,x) make.bottom.equalTo(view).offset(x);

/** 创建dict */
#define kDictInit NSMutableDictionary *dict = [NSMutableDictionary dictionary];
/** 给dict添加非空数据 */
#define kFormatParameters(KEY,VALUE)\
if (![NSString ol_isNullOrNilWithObject:(VALUE)]) {\
[dict setObject:(VALUE) forKey:(KEY)];\
}\


