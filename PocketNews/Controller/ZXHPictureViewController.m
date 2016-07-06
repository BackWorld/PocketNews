//
//  ZXHPictureViewController.m
//  PocketNews
//
//  Created by MS on 15-6-24.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHPictureViewController.h"
#import "ZXHPictureCommenCell.h"
#import "ZXHNewsCommenModel.h"
#import "UIImageView+WebCache.h"
#import "ZXHPictureDetailController.h"

@interface ZXHPictureViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZXHPictureViewController
{
    NSMutableArray *_dataSource;
    NSMutableArray *_arrTbs;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavTitle:@"图片"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray new];
    _arrTbs = [NSMutableArray new];
    
    [self initUIContent];
    
    //默认请求第一页的数据
    NSString *strUrl = [NSString stringWithFormat:kNewsUrl,kArrPictureKey[0]];
    [self startLoadDataWithUrl:strUrl];
}

-(void)initUIContent{
    //1. 父类方法
    [self setTabBarItemSeletedImg:@"tabbar_picture_hl"];

    // 分类
    [self createTopCategoryViewWithTitleArray:@[@"精选",@"奇趣",@"美女",@"故事"]];
    
    // UrlKey
    self.arrCateUrlKey = kArrPictureKey;
    
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

#pragma mark 滑动表格请求数据
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //父类方法
    [self scrollViewScroll:scrollView];
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
            [tbView registerNib:[UINib nibWithNibName:@"ZXHPictureCommenCell" bundle:nil] forCellReuseIdentifier:@"PictureCommenCellId"];
            [_arrTbs addObject:tbView];
        }
    }
}

#pragma mark 表格回调

//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

//分区视图
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0,10)];
    header.backgroundColor = [UIColor lightGrayColor];
    
    return header;
}

//分区高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}

//单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 450;
}

//单元格个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//复用
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXHPictureCommenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCommenCellId"];
    ZXHNewsCommenModel *model = _dataSource[indexPath.section];
    
    //标题
    cell.titleLabel.text = model.title;
    
    //简介
    cell.introLabel.text = model.intro;
    
    //大图
    NSArray *picList = model.pics[@"list"];
    [cell.topImgView sd_setImageWithURL:[NSURL URLWithString:picList[0][@"kpic"]]];
    
    //左，右图
    if (picList.count>=3) {
        [cell.leftImgView sd_setImageWithURL:[NSURL URLWithString:picList[1][@"kpic"]]];
        [cell.rightImgView sd_setImageWithURL:[NSURL URLWithString:picList[2][@"kpic"]]];
    }
    
    return cell;
}

#pragma mark 选中行，到详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self toDetailPage:indexPath.section isNewsDetail:NO];
}

-(void)toDetailPage:(NSInteger)index isNewsDetail:(BOOL)is{
    ZXHNewsCommenModel *model = _dataSource[index];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZXHPictureDetailController *controller = [board instantiateViewControllerWithIdentifier:@"PictureDetailControllerId"];
    
    controller.isNewsDetailPage = is;
    controller.newsId = model.newsid;
    controller.commentsCount = model.comment;
    controller.commentsId = model.comments;
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
