//
//  ZXHVideoCommenCell.h
//  PocketNews
//
//  Created by MS on 15-6-25.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHVideoCommenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *videoWebView;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UILabel *playDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;
@property (weak, nonatomic) IBOutlet UIImageView *btnPlayVideo;

@end
