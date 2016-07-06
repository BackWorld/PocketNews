//
//  ZXHPicNewsModel.h
//  PocketNews
//
//  Created by qianfeng on 15-6-27.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXHPicNewsModel : NSObject

// 标题
@property(nonatomic,copy)NSString *title;

// 评论集
@property(nonatomic,copy)NSString *comments;

// 新闻图集
@property(nonatomic,retain)NSArray *pics_module;

// 推荐图
@property(nonatomic,retain)NSArray *recommend_pic;

@end
