//
//  ZXHBaseViewController.m
//  PocketNews
//
//  Created by MS on 15-6-24.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHBaseViewController.h"
#import "GSDataManager.h"

@interface ZXHBaseViewController ()<UIScrollViewDelegate>

@end

@implementation ZXHBaseViewController
{
    UIScrollView *_mainScrollView;
    UIScrollView *_topScrollView;
    UIView *_flagView;
    CGFloat curX;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = kCommenRedColor;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    curX = _topScrollView.frame.origin.x+20;
}


//0. 顶部新闻分类
-(void)createTopCategoryViewWithTitleArray:(NSArray*)titleArr{
    //宽
    CGFloat w = 40;
    //总宽
    CGFloat conW = 20;
    
    //view
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    // scrollView
    _topScrollView = [UIScrollView new];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.tag = 0;
    
    // flagView
    _flagView = [UIView new];
    _flagView.backgroundColor = kCommenRedColor;
    _flagView.layer.zPosition = 997;
    CGRect flagFrame;
    
    // 标题
    for (int i=0;i<titleArr.count;i++) {
        NSString *title = titleArr[i];
        // title宽度
        CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].width;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(conW, 5, width+20, w-10)];
        label.tag = 999+i;
        label.font = [UIFont systemFontOfSize:16];
        label.text = title;
        // 点击手势
        label.userInteractionEnabled = 1;
        
        UITapGestureRecognizer *tap=nil;
        if (self.cateRightBtnImgName) {
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToChangePage:)];
        }else{
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToChangePage2:)];
        }
        
        [label addGestureRecognizer:tap];
        [_topScrollView addSubview:label];
        
        conW += width+20;
//        NSLog(@"title: %@, size: %f",title,width);
        
        
        if (i==0) {
            // 初始大小和位置
            _flagView.frame = CGRectMake(label.frame.origin.x, w-2, width, 2);
            flagFrame = _flagView.frame;
            [self.view addSubview:_flagView];
            
            //初始颜色
            label.textColor = kCommenRedColor;
        }
    }
    
    //右侧按钮
    if (self.cateRightBtnImgName) {
        view.frame = CGRectMake(kScreenW-w, 0, w,w);
        view.layer.zPosition = 998;
        _topScrollView.frame = CGRectMake(0, 0, kScreenW-w, w);
        
        CGFloat btnW = 24;
        CGFloat pos = w/2-btnW/2;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(pos, pos, btnW, btnW);
        [btn setBackgroundImage:[UIImage imageNamed:self.cateRightBtnImgName] forState:UIControlStateNormal];
        [view addSubview:btn];
        
        //右侧按钮分割线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_topScrollView.frame.size.width, 0, 1, w)];
        line.backgroundColor = [UIColor grayColor];
        line.layer.zPosition = 999;
        [self.view addSubview:line];
    }else
    {
        view.frame = CGRectMake(0, 0, kScreenW,w);
        _topScrollView.frame = CGRectMake(kScreenW/2-conW/2, 0, conW, w);
        flagFrame.origin.x = _topScrollView.frame.origin.x+20;
        _flagView.frame = flagFrame;
    }
    
    _topScrollView.contentSize = CGSizeMake(conW, w);
    [self.view addSubview:_topScrollView];
    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, w, kScreenW, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    //创建表格
    [self createTableView];
}

//1. tabbar选中图片
-(void)setTabBarItemSeletedImg:(NSString *)imgName{
    UIImage *selectedImg = [[UIImage imageNamed:imgName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = selectedImg;
}

//2. title
-(void)setNavTitle:(NSString *)title{
    UINavigationItem *navItem = self.navigationController.topViewController.navigationItem;
    navItem.title = title;
}

#pragma mark 创建表格
-(void)createTableView{
    
    //1. 主滚动视图
    CGFloat h = kScreenH-_topScrollView.frame.size.height-64-49;
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _topScrollView.frame.origin.y+_topScrollView.frame.size.height+1, kScreenW, h)];
    
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.tag = 1;
//    _mainScrollView.backgroundColor = [UIColor blueColor];
    
    //2. 表格
    NSArray *arrLabels = _topScrollView.subviews;
    for (int i=0; i<arrLabels.count; i++) {
        CGFloat tW = _mainScrollView.frame.size.width;
        CGFloat tH = _mainScrollView.frame.size.height;
        UITableView *tbView = [[UITableView alloc]initWithFrame:CGRectMake(tW*i, 0, tW, tH)];
        [_mainScrollView addSubview:tbView];
    }
    
    _mainScrollView.contentSize = CGSizeMake(kScreenW*arrLabels.count, _mainScrollView.frame.size.height);
    [self.view addSubview:_mainScrollView];
}



#pragma mark 切换页面
-(void)changePageWithSelectedLabel1:(UILabel*)curLabel{
    //0. 点击的label
    long curIndex = curLabel.tag;
    CGRect flagFrame = _flagView.frame;
    flagFrame.origin.x = curLabel.frame.origin.x-_topScrollView.contentOffset.x;
    flagFrame.size.width = curLabel.frame.size.width-20;
    
    //改变位置
    [UIView animateWithDuration:0.3 animations:^{
        _flagView.frame = flagFrame;
        curX = curLabel.frame.origin.x;
    }];
    
    //所有label
    NSArray *arrLabels = _topScrollView.subviews;
    for (id sub in arrLabels) {
        if ([sub isMemberOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel*)sub;
            lab.textColor = [UIColor blackColor];
        }
        if (sub == curLabel) {
            curLabel.textColor = kCommenRedColor;
        }
    }
    
    //2. 后一个label
    UILabel *nextLabel=nil;
    if (curIndex-999 < arrLabels.count) {
        nextLabel = (UILabel*)[_topScrollView viewWithTag:curIndex+1];
    }
    
    if (nextLabel.frame.origin.x+nextLabel.frame.size.width > _topScrollView.frame.size.width) {
        //大于宽度,左移
        [UIView animateWithDuration:0.3 animations:^{
            _topScrollView.contentOffset = CGPointMake(nextLabel.frame.origin.x+nextLabel.frame.size.width-_topScrollView.frame.size.width, 0);
        }];
    }
    
    //数据
    self.curPageIndex = (int)curLabel.tag-999;
    NSString *strUrl = [NSString stringWithFormat:kNewsUrl,self.arrCateUrlKey[self.curPageIndex]];
    [self startLoadDataWithUrl:strUrl];
}

-(void)changePageWithSelectedLabel2:(UILabel*)curLabel{
    //0. 点击的label
    CGRect flagFrame = _flagView.frame;
    flagFrame.origin.x = curLabel.frame.origin.x+_topScrollView.frame.origin.x;
    flagFrame.size.width = curLabel.frame.size.width-20;
    NSLog(@"cur2 %f %f",flagFrame.origin.x, curLabel.frame.origin.x);
    
    //改变位置
    [UIView animateWithDuration:0.3 animations:^{
        _flagView.frame = flagFrame;
    }];
    
    //改变颜色
    NSArray *arrLabels = _topScrollView.subviews;
    for (id sub in arrLabels) {
        if ([sub isMemberOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel*)sub;
            lab.textColor = [UIColor blackColor];
        }
        if (sub == curLabel) {
            curLabel.textColor = kCommenRedColor;
        }
    }
    
    //数据
    self.curPageIndex = (int)curLabel.tag-999;
    NSString *strUrl = [NSString stringWithFormat:kNewsUrl,self.arrCateUrlKey[self.curPageIndex]];
    [self startLoadDataWithUrl:strUrl];
}

-(void)parseData:(NSData *)data{
    NSLog(@"解析数据,子类实现");
}

#pragma mark 顶部label手势

-(void)clickToChangePage:(UITapGestureRecognizer*)tap{
    UILabel *curLabel = (UILabel*)tap.view;
    [self changePageWithSelectedLabel1:curLabel];
    [self slideToPageAtIndex:curLabel.tag-999];
    NSLog(@"cur %ld",curLabel.tag-999);
}

-(void)clickToChangePage2:(UITapGestureRecognizer*)tap{
    UILabel *curLabel = (UILabel*)tap.view;
    [self changePageWithSelectedLabel2:curLabel];
    [self slideToPageAtIndex:curLabel.tag-999];
}

#pragma mark 数据请求
-(void)startLoadDataWithUrl:(NSString*)strUrl{
    NSLog(@"%@",strUrl);
    //请求数据
    [[GSDataManager defaultManager]loadWebDataWithUrl:strUrl];
    //解析数据
    [GSDataManager defaultManager].passData = ^(NSData* data){
//        NSLog(@"%@",data);
        [self parseData:data];
    };
}


#pragma mark 滚动回调

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _topScrollView) {
        CGRect flagFrame = _flagView.frame;
        flagFrame.origin.x = curX - _topScrollView.contentOffset.x;
        _flagView.frame = flagFrame;
//        NSLog(@"x %f",_topScrollView.contentOffset.x);
    }
}

-(void)scrollViewScroll:(UIScrollView*)scrollView{
    if (scrollView == _mainScrollView) {
        NSArray *arrLabel = _topScrollView.subviews;
        int index = _mainScrollView.contentOffset.x/kScreenW;
        UILabel *curLabel = arrLabel[index];
        if (self.cateRightBtnImgName) {
            [self changePageWithSelectedLabel1:curLabel];
        }else{
            [self changePageWithSelectedLabel2:curLabel];
        }
        
        self.curPageIndex = index;
        NSLog(@"%d ",index);
    }
}

//点击时切换页面
-(void)slideToPageAtIndex:(NSInteger)index{
    [UIView animateWithDuration:0.5 animations:^{
       _mainScrollView.contentOffset = CGPointMake(kScreenW*index, 0);
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
