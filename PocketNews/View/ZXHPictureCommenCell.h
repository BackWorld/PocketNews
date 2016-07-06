//
//  ZXHPictureCommenCell.h
//  PocketNews
//
//  Created by MS on 15-6-25.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHPictureCommenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@end
