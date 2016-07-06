//
//  ZXHCommentsViewController.m
//  PocketNews
//
//  Created by qianfeng on 15-6-29.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHCommentsViewController.h"
#import "ZXHCommentCell.h"
#import "ZXHNewsCommenModel.h"
#import "GSDataManager.h"
#import "UIImageView+WebCache.h"
#import "ZXHCommentModel.h"
#import "ZXHCommentReplyView.h"

@interface ZXHCommentsViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZXHCommentsViewController
{
    NSMutableArray *_arrHotComments;
    NSMutableArray *_arrAllComments;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setCommentsVCNavUI];
    
    // 请求数据
    NSString *strUrl = [NSString stringWithFormat:kNewsCommentsUrl,self.commentsId];
    NSLog(@"%@",strUrl);
    [[GSDataManager defaultManager]loadWebDataWithUrl:strUrl];
    [GSDataManager defaultManager].passData = ^(NSData *data){
        [self parseCommentsData:data];
    };
    
    NSLog(@"评论2: %@",self.commentsId);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrHotComments = [NSMutableArray new];
    _arrAllComments = [NSMutableArray new];
    
    [self.activityView removeFromSuperview];
    
    // tbView
    [self initTbViewSetting];
}

#pragma mark 数据解析
-(void)parseCommentsData:(NSData*)data{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    // 热门评论
    NSArray *hotList = dict[@"data"][@"hotlist"];
    for (NSDictionary *comment in hotList) {
        ZXHCommentModel *model = [ZXHCommentModel new];
        [model setValuesForKeysWithDictionary:comment];
        [_arrHotComments addObject:model];
    }
    
    // 所有评论
    NSArray *cmntList = dict[@"data"][@"cmntlist"];
    for (NSDictionary *comment in cmntList) {
        ZXHCommentModel *model = [ZXHCommentModel new];
        [model setValuesForKeysWithDictionary:comment];
        [_arrAllComments addObject:model];
    }
    
    // 刷新表格数据
    [self.tbView reloadData];
}


#pragma mark 表格回调
-(void)initTbViewSetting{
    //1. 注册xib
    [self.tbView registerNib:[UINib nibWithNibName:@"ZXHCommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCellId"];
//    self.tbView.rowHeight = 300;
}

// 分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

// 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _arrHotComments.count;
    }
    return _arrAllComments.count;
}

// 头视图
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 80, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 30)];
    if (section == 0) {
        label.text = @"热门评论";
    }else{
        label.text = @"全部评论";
    }
    
    UIView *flagView = [[UIView alloc]initWithFrame:CGRectMake(20, 28, 70, 1)];
    flagView.backgroundColor = [UIColor redColor];
    [view addSubview:flagView];
    [view addSubview:label];
    
    return view;
}

// 复用
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld",indexPath.row);
    
    ZXHCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCellId"];
    
    ZXHCommentModel *model = nil;
    if (indexPath.section == 0) {
        model = _arrHotComments[indexPath.row];
    }
    if (indexPath.section == 1) {
        model = _arrAllComments[indexPath.row];
    }
    
    // 头像
    [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:model.wb_profile_img]];
    
    // 昵称
    cell.nickNameLabel.text = model.nick;
    
    // 内容
    cell.contentLabel.text = model.content;
    
    // -- 回复
    if (model.replylist.count==0) {
        cell.replyView.hidden = YES;
    }else{
        
        NSDictionary *reply = model.replylist[0];
        NSLog(@"%@",reply);
        // 记录高度
        float replyListHeight = 0;
        // 评论列表
        /*
        for (int i=0; i<model.replylist.count; i++) {
            ZXHCommentReplyView *replyView = [[NSBundle mainBundle]loadNibNamed:@"ZXHCommentReplyView" owner:self options:nil][0];

            // 昵称
            replyView.replyNickNameLabel.text = reply[@"nick"];
            // 内容
            replyView.replyContentLabel.text = reply[@"content"];
            // 楼层
            replyView.replyLevelLabel.text = [NSString stringWithFormat:@"%ld楼",[reply[@"level"] longValue]];
            
            //分割线
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, replyListHeight, replyView.frame.size.width, 1)];
            lineView.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:lineView];
            
            replyView.frame = CGRectMake(0, 100*i, cell.replyView.frame.size.width, 100);
            [cell.contentView addSubview:replyView];
            replyListHeight += replyView.frame.size.height;
        }
        */
        NSLog(@"height: %f",replyListHeight);
    }
    
    // 地区
    cell.areaLabel.text = model.area;
    
    // 赞
    cell.praisesLabel.text = model.agree;
    
    return cell;
}



#pragma mark 导航栏设置
-(void)setCommentsVCNavUI{
    [self.navBtnView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    label.text = @"全部评论";
    self.navigationItem.titleView = label;
}

@end
