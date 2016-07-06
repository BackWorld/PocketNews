//
//  ZXHSettingViewController.h
//  PocketNews
//
//  Created by MS on 15-6-24.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHBaseViewController.h"

@interface ZXHSettingViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UIImageView *headBgImgView;
- (IBAction)btnHeadLoginClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *weiboNickLabel;
- (IBAction)btnFavoriteClick:(UIButton *)sender;
- (IBAction)btnCommentClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnWeatherClick;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;




@end
