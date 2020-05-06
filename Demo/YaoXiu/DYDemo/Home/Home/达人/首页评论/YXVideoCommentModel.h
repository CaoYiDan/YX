//
//  YXVideoCommentModel.h
//  YaoXiu
//
//  Created by MAC on 2020/4/7.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXVideoCommentModel : NSObject
/** 是否是一级评论 */
@property (nonatomic, assign) BOOL isFirstLevel;
/**数据ID*/
@property (nonatomic, copy) NSString *ID;
/**评论/回复当前目标的用户头像*/
@property (nonatomic, copy) NSString *target_user_head_img;
/**当前用户是否点赞*/
@property (nonatomic, assign) int is_like;
/**视频ID*/
@property (nonatomic, copy) NSString *video_id;
/**被点赞数*/
@property (nonatomic, assign) NSInteger count_like;
/**创建时间*/
@property (nonatomic, assign) NSInteger created_at;
/**当前用户ID*/
@property (nonatomic, copy) NSString *user_id;
/**当前用户头像*/
@property (nonatomic, copy) NSString *user_head_img;
/**评论/回复当前目标的评论ID*/
@property (nonatomic, copy) NSString *target_id;
/**评论/回复当前目标的用户昵称*/
@property (nonatomic, copy) NSString *target_user_nick_name;
/**更新时间*/
@property (nonatomic, copy) NSString *updated_at;
/**当前根回复评论ID*/
@property (nonatomic, copy) NSString *root_id;
/**评论/回复当前目标的用户ID*/
@property (nonatomic, copy) NSString *target_user_id;
/**数据状态*/
@property (nonatomic, copy) NSString *status;
/**内容*/
@property (nonatomic, copy) NSString *comment_content;

/**评论人的昵称*/
@property (nonatomic, copy) NSString *user_nick_name;

/** 回复的个数 */
@property (nonatomic, assign) NSInteger count_children;

/** 子评论数组 */
@property (nonatomic, strong) NSMutableArray *childModelArr;

@end

NS_ASSUME_NONNULL_END
