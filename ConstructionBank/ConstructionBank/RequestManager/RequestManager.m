//
//  RequestManager.m
//  JuXinReview
//
//  Created by WangZhipeng on 16/4/20.
//  Copyright © 2016年 WangZhipeng. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworkActivityIndicatorManager.h>
//#import "FileModel.h"

@implementation RequestManager


+(AFHTTPSessionManager*)sharedHTTPSessionManager:(BOOL)isJSONRequest
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //请求参数设置

    if(isJSONRequest)
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    else
    {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }

    //返回参数设置
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //设置请求头
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"AppType"];
    [manager.requestSerializer setValue:@"AppStore" forHTTPHeaderField:@"Channel"];
    [manager.requestSerializer setValue:[UIDevice currentDevice].identifierForVendor.UUIDString forHTTPHeaderField:@"Deviceid"];
    [manager.requestSerializer setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"Version"];
    [manager.requestSerializer setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"versionnum"];
    [manager.requestSerializer setValue:[UIDevice currentDevice].identifierForVendor.UUIDString forHTTPHeaderField:@"did"];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"from"];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[
                                                                              @"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/x-www-form-urlencoded; charset=UTF-8"]];
    
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = 3;
    
    //请求超时的时间
    manager.requestSerializer.timeoutInterval = 60;
    
    return manager;
}


#pragma mark -- GET请求 --
+ (NSURLSessionDataTask *)getWithURLString:(NSString *)URLString
                                parameters:(id)parameters
                             isJSONRequest:(BOOL)isJSONRequest
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure {
    
    //给每个接口添加t跟m字段
    NSMutableDictionary *tmpDic = [Tools encryptionWithDictionary:parameters];
    
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager:isJSONRequest];

    NSURLSessionDataTask *session = [manager GET:URLString parameters:tmpDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSLog(@"\nget请求：Request success, URL: %@\n params:%@\n 返回内容：%@",
                  [self generateGETAbsoluteURL:URLString params:tmpDic],
                  tmpDic,responseObject);
            success( responseObject );
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSLog(@"\nGET请求：Request fail, URL: %@\n params:%@\n",
                  [self generateGETAbsoluteURL:URLString params:tmpDic],
                  tmpDic);
            failure(error);
        }
    }];
  
    return session;
}


#pragma mark -- POST请求 --
+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString
                             parameters:(id)parameters
                              isJSONRequest:(BOOL)isJSONRequest
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure {
    
    //给每个接口添加t跟m字段
    NSMutableDictionary *tmpDic = parameters;
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager:isJSONRequest];

    NSURLSessionDataTask *session = [manager POST:URLString parameters:tmpDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSLog(@"\npost请求：Request success, URL: %@\n params:%@\n 返回内容：%@",
                  [self generateGETAbsoluteURL:URLString params:tmpDic],
                  tmpDic,responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSLog(@"\npost请求：Request fail, URL: %@\n params:%@\n",
                  [self generateGETAbsoluteURL:URLString params:tmpDic],
                  tmpDic);
            failure(error);
        }
    }];
    
    
    return session;
}



#pragma mark -- POST/GET网络请求 --
+ (NSURLSessionDataTask *)requestWithURLString:(NSString *)URLString
                                    parameters:(id)parameters
                                          type:(HttpRequestType)type
                                 isJSONRequest:(BOOL)isJSONRequest
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure {
    //给每个接口添加t跟m字段
//    NSMutableDictionary *tmpDic = [Tools encryptionWithDictionary:parameters];
    NSMutableDictionary *tmpDic = parameters;
    
    NSURLSessionDataTask *session = nil;
    switch (type) {
        case HttpRequestTypeGet:
        {
            
            session = [self getWithURLString:URLString parameters:tmpDic isJSONRequest:isJSONRequest  success:^(id responseObject) {
                if (success) {
                   
                    success(responseObject);
                }
            } failure:^(NSError *error) {
                if (failure) {
                   
                    
                    failure(error);
                }
            }];
        }
            break;
        case HttpRequestTypePost:
        {
            
            [self postWithURLString:URLString parameters:tmpDic isJSONRequest:isJSONRequest success:^(id responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
    }
    
    return session;
}

+ (NSURLSessionDataTask *)encryptRequestWithURLString:(NSString *)URLString
                                    parameters:(id)parameters
                                          type:(HttpRequestType)type
                                 isJSONRequest:(BOOL)isJSONRequest
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure{
   return  [RequestManager requestWithURLString:URLString parameters:[Tools encryptionWithDictionary:parameters] type:type isJSONRequest:isJSONRequest success:success failure:failure];
}

#pragma mark -- 上传图片 --
+ (NSURLSessionDataTask *)uploadWithURLString:(NSString *)URLString
                               parameters:(id)parameters
                                 progress:(RequestProgress)progress
                              uploadParam:(NSString *)uploadParam
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure {
    //给每个接口添加t跟m字段
    NSMutableDictionary *tmpDic = [Tools encryptionWithDictionary:parameters];
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager:NO];
    NSURLSessionDataTask *session = [manager POST:URLString parameters:tmpDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *filepath = [NSURL fileURLWithPath:uploadParam];
        [formData appendPartWithFileURL:filepath name:@"image" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress){
        if(progress){
            progress(uploadProgress);
        }
        
        }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    return session;
}

+ (NSURLSessionDataTask *)uploadFileWithURLString:(NSString *)URLString
                                       parameters:(id)parameters
                                            files:(NSArray<FileModel*>*)files
                                         progress:(RequestProgress)progress
                                          success:(void (^)(id responseObject))success
                                          failure:(void (^)(NSError *error))failure
{
    //给每个接口添加t跟m字段
    NSMutableDictionary *tmpDic = [Tools encryptionWithDictionary:parameters];
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager:NO];
    NSURLSessionDataTask *session = [manager POST:URLString parameters:tmpDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for(FileModel *model in files)
        {
            NSURL *filepath = [NSURL fileURLWithPath:model.filePath];
            [formData appendPartWithFileURL:filepath name:model.fileKey error:nil];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress){
        if(progress){
            progress(uploadProgress);
        }
        
    }
                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                              if (success) {
                                                  success(responseObject);
                                              }
                                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                              if (failure) {
                                                  failure(error);
                                              }
                                          }];
    
    return session;

}



+(NSURLSessionDownloadTask *)downloadWithURLString:(NSString *)URLString
                                       savePathURL:(NSURL *)fileURL
                                          progress:(RequestProgress )progress
                                           success:(void (^)(id responseObject))success
                                           failure:(void (^)(NSError *error))failure
{
    
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager:NO];
    
    NSURL *urlpath = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            failure(error);
        }else{
            
            success(response);
        }
    }];
    
    [downloadtask resume];
    
    return downloadtask;

}

// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}



@end


@implementation FileModel



@end
