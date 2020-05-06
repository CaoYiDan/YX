//
//  DataRequest.m
//  Dream100
//
//  Created by 杨壮 on 2017/7/11.
//  Copyright © 2017年 YangZhuang. All rights reserved.
//

#import "DataRequest.h"
#import "LoginViewController.h"

@implementation DataRequest
{
    BOOL isLogin;
    BOOL isFirst;
}
static DataRequest * vc = nil;
+(id)Manager
{
    if (vc == nil)
    {
        vc = [[DataRequest alloc]init];
    }
    
    return vc;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (vc == nil)
    {
        vc = [super allocWithZone:zone];
    }
    
    return vc;
}

- (void)postBossDemoWithUrl:(NSString*)url

                     param:(NSString*)param

                   success:(void(^)(NSDictionary *dict))success

                      fail:(void (^)(NSError *error))fail

{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题

    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //不设置会报-1016或者会有编码问题

    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //不设置会报 error 3840
//    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-Api-Type"];
//
//    [manager.requestSerializer setValue:@"user" forHTTPHeaderField:@"X-Api-End"];
    
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    mediaType(MediaType.parse("application/json; charset=utf-8"))
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];

    [request addValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"iOS" forHTTPHeaderField:@"xl-api-type"];
    [request addValue:@"tse" forHTTPHeaderField:@"xl-api-end"];
    [request addValue:Token forHTTPHeaderField:@"xl-api-key"];


    NSData *body  =[param dataUsingEncoding:NSUTF8StringEncoding];

    [request setHTTPBody:body];

    

    //发起请求
  
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject,NSError * _Nullable error)

      {
          NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

    NSLog(@"=======:%@",dic);
    
              success(dic);

      }] resume];

}


- (void)SendUrl:(NSString *)url Completion:(void (^)(id))completion
{
    
    //    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-Api-Type"];

    [manager.requestSerializer setValue:@"user" forHTTPHeaderField:@"X-Api-End"];
       
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //无条件的信任服务器上的证书

    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];

    // 客户端是否信任非法证书

    securityPolicy.allowInvalidCertificates = YES;

    // 是否在证书域字段中验证域名

    securityPolicy.validatesDomainName = NO;

    manager.securityPolicy = securityPolicy;


    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/json",@"Accept:",@"q=1.0, */*; q=0.1 ", nil];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dict);
        
//        NSLog(@"JSON: %@", [[Singleton shardeManger]convertToJsonData:dict]);

        completion(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}

- (void)realNameSendUrl:(NSString *)url SendData:(NSMutableDictionary *)dic Completion:(void (^)(id))completion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    //无条件的信任服务器上的证书
//
//    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
//
//    // 客户端是否信任非法证书
//
//    securityPolicy.allowInvalidCertificates = YES;
//
//    // 是否在证书域字段中验证域名
//
//    securityPolicy.validatesDomainName = NO;
//
//    manager.securityPolicy = securityPolicy;

    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"X-Api-Type"];
//    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"X-Api-Key"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/json",@"Accept:",@"q=1.0, */*; q=0.1 ", nil];

    //http://ip:port/tech-sdkwrapper/timevale/account/addPerson
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",responseObject);

//        NSLog(@"%@\n%@",dict,dict[@"msg"]);
        completion(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)SendUrl:(NSString *)url SendData:(NSMutableDictionary *)dic Completion:(void (^)(id))completion
{
//    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//
//    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];// 客户端是否信任非法证书securityPolicy.allowInvalidCertificates = YES;// 是否在证书域字段中验证域名securityPolicy.validatesDomainName = NO;manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-Api-Type"];

    [manager.requestSerializer setValue:@"user" forHTTPHeaderField:@"X-Api-End"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
//    //无条件的信任服务器上的证书
//
//    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
//
//    // 客户端是否信任非法证书
//
//    securityPolicy.allowInvalidCertificates = YES;
//
//    // 是否在证书域字段中验证域名
//
//    securityPolicy.validatesDomainName = NO;
//
//    manager.securityPolicy = securityPolicy;

//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/json",@"Accept:",@"q=1.0, */*; q=0.1 ",@"X-Api-Key Token", nil];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];

    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

//        NSLog(@"JSON: %@", [[Singleton shardeManger]convertToJsonData:dict]);



        NSLog(@"%@",dict);

        if ([dict[@"code"] integerValue] == 400 || [dict[@"code"] integerValue] == 600 ) {
            [Singleton shardeManger].isLogin = NO;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_token"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"token"];
//            [[[Singleton shardeManger]getCurrentVC].navigationController popViewControllerAnimated:YES];
//            LoginViewController *loginVC = [[LoginViewController alloc]init];
//            [[[Singleton shardeManger]getCurrentVC].navigationController pushViewController:loginVC animated:YES];
        }

        completion(dict);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"%@",error);
    }];
}

- (void)uploadPhoto:(NSString *)url Image:(UIImage *)image radio:(CGFloat)ratio Completion:(void(^)(id responseObject))completion
{
    
    //    [SVProgressHUD showWithStatus:@"正在上传"];
    //    [SVProgressHUD dismissWithDelay:60];
    
    AFHTTPSessionManager *_manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    
        NSAssert([image isKindOfClass:[UIImage class]], @"不能上传空图片");
        
        if(ratio < 0.0||ratio > 1.0){
                ratio = 0.4;
            }
        
        NSData *data = UIImageJPEGRepresentation(image, ratio);
    
        
        [_manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:data
                                                     name:@"file"
                                                 fileName:@"233.jpg"
                                                 mimeType:@"image/jpg"];
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
            
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *result =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dict);
                
                if ([dict[@"code"] integerValue] == 200)
                    
                {

                    completion([dict objectForKey:@"data"]);

                    
                }else{
                    completion(@"失败");
                }
                
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                        }];
}



- (void)appPostForUploadVideo:(NSString *)url paramers:(NSDictionary *)paramers withVideoURL:(NSURL *)videoURL progress:(void (^)(NSProgress *))VideoUploadProgress handler:(void (^)(BOOL, NSDictionary *))handler {

    NSData *data = [NSData dataWithContentsOfURL:videoURL];
    NSString *URLStr = [videoURL absoluteString];
    NSString *fileName = [URLStr componentsSeparatedByString:@"/"].lastObject;

    //获取视频时长
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    //上面的一些信息可以作为paramer传给后台  传不传和后台商量

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:paramers constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //name传的字段应该是与后台协商一致的字段  fileName字段是后台接收后的文件名
        [formData appendPartWithFileURL:videoURL name:@"file" fileName:@"video.mov" mimeType:@"video/*" error:nil];
    } error:nil];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:VideoUploadProgress
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          //网络错误
                          handler(NO, responseObject);
                      } else {
                          handler(YES, responseObject);
                      }
                  }];

    [uploadTask resume];

    


}






@end
