//
//  ZXHSettingViewController.m
//  PocketNews
//
//  Created by MS on 15-6-24.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHSettingViewController.h"

@interface ZXHSettingViewController ()

@end

@implementation ZXHSettingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //导航栏标题
    [self setNavTitle];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUIContent];
}

-(void)initUIContent{
    //1. 标签选中图片
    [self setTabBarItemSeletedImg];
}


//1. tabbar选中图片
-(void)setTabBarItemSeletedImg{
    UIImage *selectedImg = [[UIImage imageNamed:@"tabbar_setting_hl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = selectedImg;
}

//2. title
-(void)setNavTitle{
    UINavigationItem *navItem = self.navigationController.topViewController.navigationItem;
    navItem.title = @"我的";
}

- (IBAction)btnHeadLoginClick:(UIButton *)sender {
}

- (IBAction)btnFavoriteClick:(UIButton *)sender {
}

- (IBAction)btnCommentClick:(UIButton *)sender {
}
@end
