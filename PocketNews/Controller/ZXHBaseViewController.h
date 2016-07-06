//
//  ZXHBaseViewController.h
//  PocketNews
//
//  Created by MS on 15-6-24.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHBaseViewController : UIViewController

//当前页面
@property(nonatomic,assign)int curPageIndex;
//数据源
@property(nonatomic,retain)NSMutableArray *dataSource;
// 标题个数
@property(nonatomic,retain)NSArray *titleArray;
// 顶部右边按钮
@property(nonatomic,copy)NSString *cateRightBtnImgName;
// 新闻分类url
@property(nonatomic,retain)NSArray *arrCateUrlKey;

// 给子类的接口

//1. 设置tabBar选中图片
-(void)setTabBarItemSeletedImg:(NSString *)imgName;

//2. navBar标题
-(void)setNavTitle:(NSString*)title;

//3. 顶部新闻分类
-(void)createTopCategoryViewWithTitleArray:(NSArray*)titleArr;

//解析数据
-(void)parseData:(NSData*)data;

//子类调用 -- 防止重写覆盖
-(void)scrollViewScroll:(UIScrollView*)scrollView;

//数据请求
-(void)startLoadDataWithUrl:(NSString*)strUrl;

@end
