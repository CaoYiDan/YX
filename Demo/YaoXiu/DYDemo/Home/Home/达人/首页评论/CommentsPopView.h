//
//  CommentsPopView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXVideoCommentModel;
//点击评论时回传delegate
@protocol CommentViewDelegate <NSObject>

-(void)commentViewDidSelectedModel:(YXVideoCommentModel *)model isFirstLevel:(BOOL)isFirstLevel withIndexPath:(NSIndexPath *)indexPath;

@end
//评论的类型
typedef NS_ENUM(NSInteger,CommentType){
     commentType_video,//评论视频
     commentType_comment//评论他人的评论（回复某人）
};

@interface CommentsPopView:UIView<CommentViewDelegate>

@property (nonatomic, strong) UILabel           *label;
@property (nonatomic, strong) UIImageView       *close;

- (instancetype)initWithAwemeId:(NSString *)awemeId;

/** 一共的评论人数*/
@property (nonatomic, copy) NSString *totalCommentNum;
/** 评论的类型 */
@property (nonatomic, assign) CommentType commentType;

- (void)show;
- (void)dismiss;

@end



@class YXVideoCommentModel;
@interface CommentListCell : UITableViewCell

/** indexPath */
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView        *avatar;
@property (nonatomic, strong) UIButton        *likeIcon;
@property (nonatomic, strong) UILabel            *nickName;
@property (nonatomic, strong) UILabel            *extraTag;
@property (nonatomic, strong) UILabel            *content;
@property (nonatomic, strong) UILabel            *likeNum;
@property (nonatomic, strong) UILabel            *date;
@property (nonatomic, strong) UIView             *splitLine;
/** 模型 */
@property (nonatomic, strong) YXVideoCommentModel *model;
/** 代理 */
@property (nonatomic, weak) id<CommentViewDelegate> delegate;

-(void)initData:(YXVideoCommentModel *)comment;
+(CGFloat)cellHeight:(YXVideoCommentModel *)comment;

@end

@class YXVideoCommentModel;
@interface CommentListSmallCell : UITableViewCell
/** indexPath */
@property (nonatomic, strong) NSIndexPath *indexPath;
/** container */
@property (nonatomic, strong) UIView *containerView;
/** 代理 */
@property (nonatomic, weak) id<CommentViewDelegate> delegate;
@property (nonatomic, strong) UIImageView        *avatar;
@property (nonatomic, strong) UIButton        *likeIcon;
@property (nonatomic, strong) UILabel            *nickName;
@property (nonatomic, strong) UILabel            *extraTag;
@property (nonatomic, strong) UILabel            *content;
@property (nonatomic, strong) UILabel            *likeNum;
@property (nonatomic, strong) UILabel            *date;
@property (nonatomic, strong) UIView             *splitLine;
/** 模型 */
@property (nonatomic, strong) YXVideoCommentModel *model;

-(void)initData:(YXVideoCommentModel *)comment;
+(CGFloat)cellHeight:(YXVideoCommentModel *)comment;

@end

@protocol CommentTextViewDelegate

@required
-(void)onSendText:(NSString *)text;

@end


@interface CommentTextView : UIView

@property (nonatomic, strong) UIView                         *container;
@property (nonatomic, strong) UITextView                     *textView;
@property (nonatomic, strong) id<CommentTextViewDelegate>    delegate;
@property (nonatomic, retain) UILabel            *placeholderLabel;
- (void)show;
- (void)dismiss;

@end
