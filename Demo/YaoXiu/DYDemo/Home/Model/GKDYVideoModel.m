//
//  GKDYVideoModel.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYVideoModel.h"

@implementation GKDYVideoAuthorModel

@end

@implementation GKDYVideoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"video_url":@"video_play_url",
             @"thumbnail_url":@"video_cover_url",
             @"first_frame_cover":@"video_cover_url",
             @"title":@"video_title",
             @"post_id":@"id",
             @"share_num":@"count_relay",
             @"comment_num":@"count_comment",
             @"agree_num":@"count_like",
             @"author.name_show":@"video_title",
             @"isAgree":@"is_like",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"author" : [GKDYVideoAuthorModel class]};
}

@end
