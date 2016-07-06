//
//  ZXHVideoViewController.m
//  PocketNews
//
//  Created by MS on 15-6-24.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//
#define kVideoUrl @"http://202.201.14.183/edge.v.iask.com/138340774.mp4?KID=sina,viask&Expires=1435507200&ssig=%2F6iCNIxWCE&wshc_tag=1&wsts_tag=558e3201&wsid_tag=757297ab&wsiphost=ipdbm"

#import "ZXHVideoViewController.h"
#import "ZXHVideoCommenCell.h"
#import "ZXHNewsCommenModel.h"
#import "ZXHVideoCommenCell.h"
#import "UIImageView+WebCache.h"

@interface ZXHVideoViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@end

@implementation ZXHVideoViewController
{
    NSMutableArray *_dataSource;
    NSMutableArray *_arrTbs;
    NSMutableArray *_arrVideoSrc;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavTitle:@"图片"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray new];
    _arrTbs = [NSMutableArray new];
    _arrVideoSrc = [NSMutableArray new];
    
    [self initUIContent];
    
    //默认请求第一页的数据
    NSString *strUrl = [NSString stringWithFormat:kNewsUrl,kArrVideoKey[0]];
    [self startLoadDataWithUrl:strUrl];
}

-(void)initUIContent{
    //1. 父类方法
    [self setTabBarItemSeletedImg:@"tabbar_picture_hl"];
    
    // 分类
    [self createTopCategoryViewWithTitleArray:@[@"精选",@"奇趣",@"美女",@"故事"]];
    
    // UrlKey
    self.arrCateUrlKey = kArrVideoKey;
    
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
    //清空视频源
//    [_arrVideoSrc removeAllObjects];
    
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
            [tbView registerNib:[UINib nibWithNibName:@"ZXHVideoCommenCell" bundle:nil] forCellReuseIdentifier:@"VideoCommenCellId"];
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
    return 300;
}

//单元格个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//复用
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXHVideoCommenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCommenCellId"];
    ZXHNewsCommenModel *model = _dataSource[indexPath.section];
    
    //图片
    [cell.videoImgView sd_setImageWithURL:[NSURL URLWithString:model.video_info[@"kpic"]]];
    //  手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startPlayVideo:)];
    [cell.btnPlayVideo addGestureRecognizer:tap];
    cell.btnPlayVideo.tag = indexPath.section;
    
    //时长
    int time = [model.video_info[@"runtime"] floatValue];
    int min = time/60000;
    int sec = (time-min*60000)/1000;
    cell.playDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    
    //标题
    cell.titleLabel.text = model.title;
    
    //视频
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:model.link]];
    [cell.videoWebView loadRequest:request];
    cell.videoWebView.delegate = self;
    cell.videoImgView.tag = indexPath.section + 22222;
    cell.videoWebView.tag = cell.videoImgView.tag+10000;
    
    return cell;
}

// 开始播放视频 - 图片点击手势
-(void)startPlayVideo:(UITapGestureRecognizer*)tap{
    // 播放按钮
    NSInteger index = tap.view.tag;
    tap.view.superview.hidden = YES;
    
    // 预览图
    NSInteger imgTag = index+22222;
    UIImageView *videoImg = (UIImageView*)[tap.view.superview.superview viewWithTag:imgTag];
    videoImg.hidden = YES;
    
    // 加载视频
    ZXHNewsCommenModel *model = _dataSource[index];
    NSURL *url = [NSURL URLWithString:model.video_info[@"url"]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    UIWebView *webView = (UIWebView*)[tap.view.superview.superview viewWithTag:imgTag+10000];
    webView.scrollView.scrollEnabled = NO;
    
    [webView loadRequest:request];
}

#pragma mark webView回调
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
}






@end
