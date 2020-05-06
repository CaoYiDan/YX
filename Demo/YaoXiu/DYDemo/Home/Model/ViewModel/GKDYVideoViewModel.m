//
//  GKDYVideoViewModel.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYVideoViewModel.h"
#import "GKNetworking.h"

#define  pageSize 8 //一页请求多少数据

@interface GKDYVideoViewModel()

// 页码
@property (nonatomic, assign) NSInteger pn;

@end

@implementation GKDYVideoViewModel

//获取请求的dataDic
-(NSMutableDictionary *)p_getDataDic{
    
    kDictInit
    if (self.requestType == RequestTypeSomeOne) {
        
        kFormatParameters(@"id",self.target_user_id)
        
    }else if(self.requestType == RequestTypeWishMan){
        
    }else if(self.requestType == RequestTypeCommonCity){
        
    kFormatParameters(@"user_longitude",m_UserDefaultObjectForKey(Account_Longitude));
        kFormatParameters(@"user_latitude", m_UserDefaultObjectForKey(Account_Latitude));
        
    }
    return dict;
}

-(NSString *)getUrl{
    
    NSString *url = @"";
    if (self.requestType == RequestTypeSomeOne) {
        
        url = YXUserVideo;
        
    }else if(self.requestType == RequestTypeWishMan){
        url = YXUserVideo;
        
    }else if(self.requestType == RequestTypeCommonCity){
        url = YXMerchantVideo;
    }
    return url;
}

- (void)refreshNewListWithSuccess:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    
    self.pn = 0;
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:[self p_getDataDic] forKey:@"data"];
    [dic setObject:@"list" forKey:@"action"];
    [dic setObject:@{@"index":@(self.pn),@"size":@(pageSize)} forKey:@"paging"];
    [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];
    NSLog(@"%@",dic);
    
    [[HttpRequest sharedClient]postWithUrl:[self getUrl] body:dic success:^(NSDictionary *response) {
       
        NSMutableArray *list = @[].mutableCopy;
        for (NSDictionary *childDic  in response[@"data"]) {
            [list addObject: [GKDYVideoModel yy_modelWithDictionary:childDic]];
        }
    
        !success ? : success(list);
        
    } failure:^(NSError *error) {
        
    }];
   
  
}

- (void)refreshMoreListWithSuccess:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    self.pn ++;
 
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:[self p_getDataDic] forKey:@"data"];
    [dic setObject:@"list" forKey:@"action"];
    [dic setObject:@{@"index":@(self.pn),@"size":@(pageSize)} forKey:@"paging"];
    [dic setObject:m_UserDefaultObjectForKey(Account_Access_Token) forKey:@"access_token"];
    
    [[HttpRequest sharedClient]postWithUrl:[self getUrl] body:dic success:^(NSDictionary *response) {
       
        NSMutableArray *list = @[].mutableCopy;
        for (NSDictionary *childDic  in response[@"data"]) {
            [list addObject: [GKDYVideoModel yy_modelWithDictionary:childDic]];
        }
        if (list.count==0) {
            m_ToastCenter(@"呀，暂无更多了。");
        }
        !success ? : success(list);
        
    } failure:^(NSError *error) {
        
    }];
       
}

@end
