//
//  ZXHNewsCommenCell.h
//  PocketNews
//
//  Created by MS on 15-6-25.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHNewsCommenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cateImgView;

@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;


@end
