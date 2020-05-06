//
//  HttpRequest.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/6/26.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"
//#import "AFSecurityPolicy.h"

//#include <CommonCrypto/CommonDigest.h>
//#include <CommonCrypto/CommonHMAC.h>
//static NSString * const  key = @"secret7496";
@implementation HttpRequest

+ (HttpRequest *)sharedClient{
    static HttpRequest *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    return _sharedClient;
}

-(AFHTTPSessionManager*)manager{
    static AFHTTPSessionManager *_managera = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _managera = [self getManager];
    });
    return _managera;
}

-(AFHTTPSessionManager*)getManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    return manager;
    
    //最大请求并发任务数
    manager.operationQueue.maxConcurrentOperationCount = 5;
    
    // 请求格式
    // AFHTTPRequestSerializer            二进制格式
    // AFJSONRequestSerializer            JSON
    // AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30.0f;
    // 设置请求头
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    
    // 返回格式
    // AFHTTPResponseSerializer           二进制格式
    // AFJSONResponseSerializer           JSON
    // AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
    // AFXMLDocumentResponseSerializer (Mac OS X)
    // AFPropertyListResponseSerializer   PList
    // AFImageResponseSerializer          Image
    // AFCompoundResponseSerializer       组合
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    
    //设置返回C的ontent-type
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    
    return manager;
}

//取消网络请求
- (void) cancelRequest
{
    
}


//GET请求
-(void)httpRequestGET:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure  {
    
    AFHTTPSessionManager *manager  = [self getManager];
    [manager GET: string parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress!= nil) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucess(task,responseObject,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}


//POST请求
- (void)DianGuihttpRequestPOST:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure {
  
    string = @"https://xlhdtsm.zhixingonline.com/cabinet/list";
    parmeters = @{@"limit":@"10",@"page":@(1)};
      self.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题

    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    [self.manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"xl-api-type"];
    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.manager.requestSerializer setValue:@"1vEMOHIJ8Ok3p00HsrsdUzYCVr72yIcv" forHTTPHeaderField:@"xl-api-key"];
    [self.manager.requestSerializer setValue:@"tsm" forHTTPHeaderField:@"xl-api-end"];
    [self.manager POST:string parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress!= nil) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功
        sucess(task,responseObject,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
        NSLog(@"%@",error);
        failure(task,error);
      
    }];
}

//POST请求
- (void)httpRequestPOST:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure {
  
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager POST:string parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress!= nil) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功
        sucess(task,responseObject,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
        failure(task,error);
      
    }];
}

//POST请求
- (void)httpRequestPOSTJSON:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure{
      NSData *postData = [parmeters dataUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lu",postData.length] forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:string parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress!= nil) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功
       NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",receiveStr);
    
        if (![receiveStr containsString:@"0003"]){
            
        }else{
        sucess(task,receiveStr,receiveStr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        failure(task,error);
        
    }];
}

#pragma  mark  将字符串转成字典
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/**
 *  异步POST请求:以body方式,支持数组
 *
 *  @param url     请求的url
 *  @param body    字典
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)postWithUrl:(NSString *)url body:(NSMutableDictionary *)body success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failure
{
    // 请求参数数据
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:&error];
    
    // 创建配置信息
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    configure.timeoutIntervalForRequest = 10;// 设置超时时间
    // 创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configure delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // 请求
    NSURL *url2 = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url2 cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request addValue:@"raw" forHTTPHeaderField:@"Content-Type"];// 设置请求类型
    [request setHTTPMethod:@"POST"];// 设置请求方法
    [request setHTTPBody:jsonData];// 设置请求参数
    NSLog(@"dic==%@",body);
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",object);
            
            NSString *status = NUMBER_TO_STRING(object[@"status"]);
            //如果是200 请求正确，
            if ( [status isEqualToString:@"200"] ) {
                 // 返回数据
                 success(object);
            }else{
                m_ToastCenter(object[@"error"]);
            }

        } else {
            NSLog(@"生成pdf❌.....%@",error);
        }
    }];
    [task resume];
    
}

//专门为GETCity请求
-(void)httpRequestForCityGET:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure  {
    
    [self.manager.requestSerializer setValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
    [self.manager.requestSerializer setValue:@"application/json"  forHTTPHeaderField:@"Accept"];
    self.manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    // 设置超时时间
    [self.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.manager.requestSerializer.timeoutInterval = 5.f;
    [self.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [self.manager GET:  string parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress!= nil) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucess(task,responseObject,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}
@end
