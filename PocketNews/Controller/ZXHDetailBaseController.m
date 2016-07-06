//
//  ZXHDetailBaseController.m
//  PocketNews
//
//  Created by qianfeng on 15-6-29.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHDetailBaseController.h"
#import "GSDataManager.h"

@interface ZXHDetailBaseController ()

@end

static NSString *cmntId;

@implementation ZXHDetailBaseController
{
    BOOL _isLiked;
    BOOL _isFavorited;
    BOOL _isLoading;
}

// 单例传值


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //1. nav
    [self setNavUI];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _isLiked = NO;
    _isFavorited = NO;
    
    //2. 菊花指示
    [self setLoadingIndicator];
}

#pragma mark 菊花
-(void)setLoadingIndicator{
    CGFloat wh = 80;
    _activityView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2-wh/2, kScreenH/2-wh, wh, wh)];
    _activityView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _activityView.tag = 10000;
    _activityView.layer.cornerRadius = 10;
    [self.view addSubview:_activityView];
    
    // 加载指示
    CGFloat iwh = 30;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(wh/2-iwh/2, wh/2-iwh/2-10, iwh, iwh)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    indicator.tintColor = kCommenRedColor;
    [indicator startAnimating];
    [_activityView addSubview:indicator];
    
    // label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, indicator.frame.origin.y+iwh, wh, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"拼命加载中...";
    [_activityView addSubview:label];
}

#pragma mark 导航栏
-(void)setNavUI{
    // -- 左边按钮
    UINavigationItem *navItem = self.navigationItem;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21, 21);
    navItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:backBtn]];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navBtnView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW-140, 10, 140, 21)];
    //    naview.backgroundColor = [UIColor greenColor];
    
    // -- 喜欢按钮
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.frame = CGRectMake(0, 0, 21, 21);
    [likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // -- 收藏按钮
    UIButton *favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBtn.frame = CGRectMake(51, 0, 21, 21);
    [favoriteBtn addTarget:self action:@selector(favoriteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // -- 分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(102, 0, 21, 21);
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // -- 导航栏颜色
    if (self.isNewsDetailPage) {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"navigationBarItem_like_normal"] forState:UIControlStateNormal];
        [favoriteBtn setImage:[UIImage imageNamed:@"navigationBarItem_favorite_normal"] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:@"navigationbar_share_icon"] forState:UIControlStateNormal];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
    }else{
        self.view.backgroundColor = [UIColor blackColor];
        self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
        [backBtn setImage:[UIImage imageNamed:@"navigationbar_pic_back_icon"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"navigationBarItem_like_normal_PB"] forState:UIControlStateNormal];
        [favoriteBtn setImage:[UIImage imageNamed:@"navigationBarItem_favorite_normal_PB"] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:@"navigationbar_pic_share_icon"] forState:UIControlStateNormal];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    [self.navBtnView addSubview:likeBtn];
    [self.navBtnView addSubview:favoriteBtn];
    [self.navBtnView addSubview:shareBtn];
    
    [self.navigationController.navigationBar addSubview:self.navBtnView];
}

// 返回
-(void)backBtnClick{
//    NSArray *subs = self.navigationController.navigationBar.subviews;
//    for (id sub in subs) {
//        if ([sub isMemberOfClass:[UIView class]]) {
//            [sub removeFromSuperview];
//        }
//    }
    self.navBtnView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}



// 喜欢
-(void)likeBtnClick:(UIButton*)btn{
    if (self.isNewsDetailPage) {
        if (!_isLiked) {
            [btn setImage:[UIImage imageNamed:@"navigationBarItem_liked_normal"] forState:UIControlStateNormal];
            NSLog(@"已喜欢");
        }else{
            [btn setImage:[UIImage imageNamed:@"navigationBarItem_like_normal"] forState:UIControlStateNormal];
            NSLog(@"已取消喜欢");
        }
    }else{
        if (!_isLiked) {
            [btn setImage:[UIImage imageNamed:@"navigationBarItem_liked_normal_PB"] forState:UIControlStateNormal];
            NSLog(@"已喜欢");
        }else{
            [btn setImage:[UIImage imageNamed:@"navigationBarItem_like_normal_PB"] forState:UIControlStateNormal];
            NSLog(@"已取消喜欢");
        }
    }
    _isLiked = !_isLiked;
}

// 收藏
-(void)favoriteBtnClick:(UIButton*)btn{
    if (self.isNewsDetailPage) {
        if (!_isFavorited) {
            [btn setImage:[UIImage imageNamed:@"navigationBarItem_favorited_normal"] forState:UIControlStateNormal];
            NSLog(@"已收藏");
        }else{
            [btn setImage:[UIImage imageNamed:@"navigationBarItem_favorite_normal"] forState:UIControlStateNormal];
            NSLog(@"已取消收藏");
        }
        
    }else{
        if (!_isFavorited) {
            [btn setImage:[UIImage imageNamed:@"navigationBarItem_favorited_normal_PB"] forState:UIControlStateNormal];
            NSLog(@"已收藏");
        }else{
            [btn setImage:[UIImage imageNamed:@"navigationBarItem_favorite_normal_PB"] forState:UIControlStateNormal];
            NSLog(@"已取消收藏");
        }
    }
    _isFavorited = !_isFavorited;
}

// 分享
-(void)shareBtnClick:(UIButton*)btn{
    NSLog(@"分享");
}

@end
