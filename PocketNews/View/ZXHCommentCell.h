//
//  ZXHCommentCell.h
//  PocketNews
//
//  Created by qianfeng on 15-6-29.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXHCommentReplyView.h"

@interface ZXHCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIView *replyBtnView;
@property (weak, nonatomic) IBOutlet UIView *praiseBtnView;
@property (weak, nonatomic) IBOutlet UILabel *praisesLabel;

@property (weak, nonatomic) IBOutlet UIView *replyView;



@end
