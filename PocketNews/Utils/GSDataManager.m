//
//  GSDataManager.m
//  GlassesStore
//
//  Created by MS on 15-6-21.
//  Copyright (c) 2015年 CS. All rights reserved.
//

#import "GSDataManager.h"
#import "AFNetworking.h"

@implementation GSDataManager
{
    NSURLSessionDataTask *_dataTask;
}

static GSDataManager *manager;
+(GSDataManager *)defaultManager{
    if (!manager) {
        manager = [GSDataManager new];
    }
    return manager;
}

-(void)loadWebDataWithUrl:(NSString *)strUrl{
/*
    //用NSURLSession请求数据
//    strUrl = @"http://10.0.8.8/sns/my/user_list.php?page=1&number=30";
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:strUrl]];
    NSURLSession *session = [NSURLSession sharedSession];
    _dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@",strUrl);
        NSLog(@"%@",data);
        //传递数据
        if (_passData) {
            _passData(data);
        }
    }];
    //启动任务
    [_dataTask resume];*/
    
    //请求类单例对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //手动解析
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //POST请求 -- post的参数 少量数据
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",strUrl);
        //传递数据
        if (_passData) {
            _passData(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求数据失败: %@",error);
    }];
}

@end
