//
//  ZXHCommentsViewController.h
//  PocketNews
//
//  Created by qianfeng on 15-6-29.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHDetailBaseController.h"

@interface ZXHCommentsViewController : ZXHDetailBaseController
//评论集Id
@property(nonatomic,copy)NSString *commentsId;

@property (weak, nonatomic) IBOutlet UITableView *tbView;

@end
