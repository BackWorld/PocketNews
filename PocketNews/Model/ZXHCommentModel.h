//
//  ZXHCommentModel.h
//  PocketNews
//
//  Created by qianfeng on 15-6-27.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXHCommentModel : NSObject

// 头像
@property(nonatomic,copy)NSString *wb_profile_img;

// 昵称
@property(nonatomic,copy)NSString *nick;

// 时间
@property(nonatomic,assign)long time;

// 内容
@property(nonatomic,copy)NSString *content;

// 地区
@property(nonatomic,copy)NSString *area;

// 赞
@property(nonatomic,copy)NSString *agree;

// --- 回复列表
@property(nonatomic,retain)NSArray *replylist;

@end
