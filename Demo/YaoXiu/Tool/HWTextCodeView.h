//
//  CodeTextDemo
//
//  Created by 小侯爷 on 2018/9/20.
//  Copyright © 2018年 小侯爷. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


 @protocol HWTextCodeViewDelegate <NSObject>
 // 由于这里没有任何修饰词所以是默认的代理方法，切记默认的代理方法，如果遵守了协议那就必须实现
/**
  *  @Description item选中跳转对应的控制器
  *  @param 被点击的按钮
  */
 - (void)getCodeStr:(NSString *)code;

// 只是为了演示这儿是想说明下边这个方法是可选的就是可以实现也可以不实现
 @optional

 - (void)optionalFouction;

 @end

/**
 * 完善版 - 加入动画 - 下划线
 */
@interface HWTextCodeView : UIView

/// 当前输入的内容
@property (nonatomic, copy, readonly) NSString *code;

@property (nonatomic, weak) UITextField *textField;

/// 临时保存上次输入的内容(用于判断 删除 还是 输入)
@property (nonatomic, copy) NSString *tempStr;

@property(nonatomic,weak)id<HWTextCodeViewDelegate> delegate;

- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end



// ------------------------------------------------------------------------
// -----------------------------HWTC_lineView------------------------------
// ------------------------------------------------------------------------


@interface HWTC_lineView : UIView

@property (nonatomic, weak) UIView *colorView;

- (void)animation;

@end

NS_ASSUME_NONNULL_END
