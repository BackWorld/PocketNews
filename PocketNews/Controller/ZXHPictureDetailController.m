//
//  ZXHPictureDetailController.m
//  PocketNews
//
//  Created by qianfeng on 15-6-29.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHPictureDetailController.h"
#import "ZXHPicNewsModel.h"
#import "UIImageView+WebCache.h"
#import "GSDataManager.h"
#import "ZXHCommentsViewController.h"

@interface ZXHPictureDetailController ()<UIScrollViewDelegate>

@end

@implementation ZXHPictureDetailController
{
    ZXHPicNewsModel *_picModel;
    NSArray *_arrPic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. 数据源
    _picModel = [ZXHPicNewsModel new];
    _arrPic = [NSArray new];
    
    [self.btnCommentsView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toCommentsPage)]];
    
    //2. 请求数据
    NSString *strUrl = [NSString stringWithFormat:kNewsDetailUrl,self.newsId];
    [[GSDataManager defaultManager]loadWebDataWithUrl:strUrl];
    
    //3. 解析数据
    [GSDataManager defaultManager].passData = ^(NSData *data){
        [self parseData:data];
        
        //数据请求成功再创建UI对象
        [self setUIContent];
    };
    
    
    NSLog(@"评论: %@",self.commentsId);
}

#pragma mark UI设置
-(void)setUIContent{
    // 图片集
    _arrPic = _picModel.pics_module[0][@"data"];
    self.scrollView.contentSize = CGSizeMake(_arrPic.count*kScreenW, self.view.frame.size.height);
    
    int x=0;
    for (NSDictionary *pic in _arrPic) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(x*kScreenW, 0, kScreenW, 0)];
        // 点击手势
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTaped:)]];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:pic[@"kpic"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            // 图片宽高
            CGFloat W = image.size.width;
            CGFloat H = image.size.height;
            float scale = kScreenW/W;
            
            //重设imgView的 frame
            CGRect iFrame = imgView.frame;
            iFrame.size.height = H*scale;
            iFrame.origin.y = self.scrollView.frame.size.height/2 - iFrame.size.height/2;
            imgView.frame = iFrame;
            
        }];
        
        [self.scrollView addSubview:imgView];
        x++;
    }
    
    //移除加载指示
    [self.activityView removeFromSuperview];
    
    //默认显示的图片简介
    [self setNewsInfoIndex:0];
    
    //评论数
    self.commentsLabel.text = [NSString stringWithFormat:@"%ld",self.commentsCount];
}

#pragma mark 隐藏导航栏和文字描述视图
-(void)imgViewTaped:(UITapGestureRecognizer*)tap{
//    NSLog(@"隐藏导航栏和文字描述视图");
    
    if (!self.wordsView.hidden) {
        self.navigationController.navigationBar.hidden = YES;
        self.wordsView.hidden = YES;
    }else{
        self.navigationController.navigationBar.hidden = NO;
        self.wordsView.hidden = NO;
    }
}

#pragma mark 解析数据
-(void)parseData:(NSData *)data{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_picModel setValuesForKeysWithDictionary:dict[@"data"]];
//    NSLog(@"%@",_picModel);
}

#pragma mark 滑动图片回调
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        int index = scrollView.contentOffset.x/kScreenW;
        [self setNewsInfoIndex:index];
    }
}

-(void)setNewsInfoIndex: (int)index{
    NSDictionary *dict = _arrPic[index];
    
    // 设置title
    self.titleLabel.text = _picModel.title;
    
    // 图片解说
//    NSLog(@"%@",dict[@"alt"]);
    self.altLabel.text = dict[@"alt"];
    
    // 设置页数
    NSMutableAttributedString *pageInfo = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d/%ld",++index,_arrPic.count]];
    NSInteger len = [NSString stringWithFormat:@"%d",index].length;
    [pageInfo addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, len)];
    self.picCountLabel.attributedText = pageInfo;
}


#pragma mark 点击手势，到评论列表视图
-(void)toCommentsPage{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZXHCommentsViewController *commentsVC = [board instantiateViewControllerWithIdentifier:@"CommentsViewControllerId"];
    commentsVC.isNewsDetailPage = YES;
    commentsVC.commentsId = self.commentsId;
    
    // 隐藏导航栏按钮
    self.navBtnView.hidden = YES;
    [self.navigationController pushViewController:commentsVC animated:1];
}
@end
