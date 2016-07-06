//
//  ZXHNewsCommenModel.h
//  PocketNews
//
//  Created by MS on 15-6-25.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXHNewsCommenModel : NSObject

// 新闻类型
@property(nonatomic,copy)NSString *category;

// 新闻id，跳到详情页时使用
@property(nonatomic,copy)NSString *newsid;

// 标题
@property(nonatomic,copy)NSString *title;

// 新闻链接
@property(nonatomic,copy)NSString *link;

// 封面图
@property(nonatomic,copy)NSString *kpic;

// 简介
@property(nonatomic,copy)NSString *intro;

// 图片新闻
@property(nonatomic,retain)NSDictionary *pics;

// 视频新闻
@property(nonatomic,retain)NSDictionary *video_info;

// 评论数
@property(nonatomic,assign)long comment;

// 所有评论
@property(nonatomic,copy)NSString *comments;


@end
