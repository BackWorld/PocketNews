//
//  ZXHDetailBaseController.h
//  PocketNews
//
//  Created by qianfeng on 15-6-29.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHDetailBaseController : UIViewController

// 导航栏按钮视图
@property(nonatomic,retain)UIView *navBtnView;
// 数据加载指示
@property(nonatomic,retain)UIView *activityView;

//url
@property(nonatomic,copy)NSString *newsId;

//是哪个页面的跳转
@property(nonatomic,assign)BOOL isNewsDetailPage;

// 评论数
@property(nonatomic,assign)long commentsCount;

// 评论集
@property(nonatomic,copy)NSString *commentsId;


@end
