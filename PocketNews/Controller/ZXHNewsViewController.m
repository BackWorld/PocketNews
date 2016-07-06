//
//  ZXHNewsViewController.m
//  PocketNews
//
//  Created by MS on 15-6-24.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHNewsViewController.h"
#import "ZXHNewsCommenCell.h"
#import "ZXHNewsCommenModel.h"
#import "UIImageView+WebCache.h"
#import "ZXHNewsDetailController.h"
#import "ZXHPictureDetailController.h"
#import "ZXHDetailBaseController.h"

@interface ZXHNewsViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@end

@implementation ZXHNewsViewController
{
    NSMutableArray *_dataSource;
    NSMutableArray *_arrTbs;
    NSMutableArray *_arrSlides;
    
    UIScrollView *_slideScrollView;
    UILabel *_slideTitleLabel;
    UIPageControl *_slidePageControl;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavTitle:@"新闻"];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray new];
    
    //所有表格对象
    _arrTbs = [NSMutableArray new];
    
    //幻灯图片
    _arrSlides = [NSMutableArray new];
    
    [self initUIContent];
    
    //默认请求第一页的数据
    NSString *strUrl = [NSString stringWithFormat:kNewsUrl,kArrNewsKey[0]];
    [self startLoadDataWithUrl:strUrl];
}

-(void)initUIContent{
    //1. 父类方法
    [self setTabBarItemSeletedImg:@"tabbar_news_hl"];
    
    // 顶部分类按钮
    self.cateRightBtnImgName = @"slideTab_rightButton";
    
    // 分类
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"cate_list.json" withExtension:nil];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *arr = [NSMutableArray new];
    for (NSDictionary *dic in dict[@"data"]) {
        [arr addObject:dic[@"name"]];
    }
    [self createTopCategoryViewWithTitleArray:arr];
    
    // UrlKey
    self.arrCateUrlKey = kArrNewsKey;
    
    // 表格
    [self initTableView];
}

#pragma mark 解析数据
-(void)parseData:(NSData*)data{
    //下次请求，清空数据源
    [_dataSource removeAllObjects];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary *dic in dict[@"data"][@"list"]) {
        ZXHNewsCommenModel *model = [ZXHNewsCommenModel new];
        [model setValuesForKeysWithDictionary:dic];
        [_dataSource addObject:model];
    }
    
    //刷新表格数据
    UITableView *curTbView = _arrTbs[self.curPageIndex];
    [curTbView reloadData];
//    NSLog(@"data %@",dict);
}

#pragma mark 初始表格设置
-(void)initTableView{
    UIScrollView *mainScrollView = (UIScrollView*)[self.view viewWithTag:1];
    for (id sub in mainScrollView.subviews) {
        if ([sub isMemberOfClass:[UITableView class]]) {
            UITableView *tbView = (UITableView*)sub;
            tbView.dataSource = self;
            tbView.delegate = self;
            // 注册xib
            [tbView registerNib:[UINib nibWithNibName:@"ZXHNewsCommenCell" bundle:nil] forCellReuseIdentifier:@"NewsCommenCellId"];
            // 保存起来
            [_arrTbs addObject:tbView];
        }
    }
}

#pragma mark 表格回调
//section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

//单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 200;
    }
    return 100;
}

//表头视图
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

//section个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//单元格个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count-4;
}

//复用
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // 幻灯视图
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsSlideCellId"];
        cell.backgroundColor = [UIColor orangeColor];
        
        CGFloat cH = 200;
        CGFloat pH = 30;
        
        //创建slide scrollView
        _slideScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, cH)];
        _slideScrollView.contentSize = CGSizeMake(kScreenW*5, cH);
        [cell.contentView addSubview:_slideScrollView];
        _slideScrollView.pagingEnabled = YES;
        _slideScrollView.showsHorizontalScrollIndicator = NO;
        _slideScrollView.tag = 111;
        _slideScrollView.delegate = self;
        
        //pageControl
        
        UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(0, cH-pH, kScreenW, pH)];
        pageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [cell.contentView addSubview:pageView];
        
        _slideTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenW-80, pH)];
        _slideTitleLabel.textColor = [UIColor whiteColor];
        _slideTitleLabel.font = [UIFont systemFontOfSize:14];
        [pageView addSubview:_slideTitleLabel];
        
        _slidePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(_slideTitleLabel.frame.size.width, 0, 80, pH)];
        _slidePageControl.numberOfPages = 5;
        [pageView addSubview:_slidePageControl];
        _slidePageControl.tintColor = [UIColor whiteColor];
        _slidePageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        //下次请求数据，清空
        [_arrSlides removeAllObjects];
        
        for (int i=0; i<5; i++) {
            ZXHNewsCommenModel *model = _dataSource[i];
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW*i, 0, kScreenW, cH)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.kpic]];
            
            // 点击手势
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(slideImgTaped:)]];
            imgView.tag = 9999+i;
            
            [_slideScrollView addSubview:imgView];
            if (i==0) {
                _slideTitleLabel.text = model.title;
            }
            //保存model
            [_arrSlides addObject:model];
        }
        
        return cell;
    }
    
    ZXHNewsCommenModel *model = _dataSource[indexPath.row];
    ZXHNewsCommenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCommenCellId"];
    // 图片
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:model.kpic]];
    
    // 标题
    cell.titleLabel.text = model.title;
    
    // 简介
    cell.introLabel.text = model.intro;
    
    // 评论
    
    if (model.comment > 0) {
        cell.commentLabel.text = [NSString stringWithFormat:@"%ld评论",model.comment];
    }
    
    // 类别
    cell.cateImgView.image = nil;
    if ([model.category isEqualToString:@"consice"]) {
        cell.cateImgView.image = [UIImage imageNamed:@"feed_cell_concise_mark"];
    }
    if ([model.category isEqualToString:@"subject"] || [model.category isEqualToString:@"recommend"]) {
        cell.cateImgView.image = [UIImage imageNamed:@"feed_cell_subject_mark"];
    }
    if ([model.category isEqualToString:@"live"]) {
        cell.cateImgView.image = [UIImage imageNamed:@"feed_cell_live_mark"];
    }
    if ([model.category isEqualToString:@"exclusive"]) {
        cell.cateImgView.image = [UIImage imageNamed:@"feed_cell_exclusive_mark"];
    }
    if ([model.category isEqualToString:@"sponsor"]) {
        cell.cateImgView.image = [UIImage imageNamed:@"feed_cell_sponsor_mark"];
    }
    if ([model.category isEqualToString:@"promote"]) {
        cell.cateImgView.image = [UIImage imageNamed:@"feed_cell_promote_mark"];
    }
    
    return cell;
}

#pragma mark 滑动表格请求数据
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //父类方法
    [self scrollViewScroll:scrollView];
    
    if (scrollView == _slideScrollView) {
        int page = _slideScrollView.contentOffset.x/kScreenW;
        ZXHNewsCommenModel *model = _arrSlides[page];
        _slidePageControl.currentPage = page;
        _slideTitleLabel.text = model.title;
    }
}

#pragma mark 选中行，到详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0) {
        ZXHNewsCommenModel *model = _dataSource[indexPath.row];
        if (model.pics) {
            [self toDetailPage:indexPath.row isNewsDetail:NO];
        }else{
            [self toDetailPage:indexPath.row isNewsDetail:YES];
        }
    }
}

-(void)toDetailPage:(NSInteger)index isNewsDetail:(BOOL)is{
    ZXHNewsCommenModel *model = _dataSource[index];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZXHDetailBaseController *controller = [board instantiateViewControllerWithIdentifier:@"PictureDetailControllerId"];
    if (is) {
        controller = [board instantiateViewControllerWithIdentifier:@"NewsDetailControllerId"];
    }
    controller.isNewsDetailPage = is;
    controller.newsId = model.newsid;
    controller.commentsCount = model.comment;
    controller.commentsId = model.comments;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 幻灯片手势
-(void)slideImgTaped:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag - 9999;
    
    [self toDetailPage:index isNewsDetail:NO];
}

@end
