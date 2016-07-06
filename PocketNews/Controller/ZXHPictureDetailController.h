//
//  ZXHPictureDetailController.h
//  PocketNews
//
//  Created by qianfeng on 15-6-29.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHDetailBaseController.h"

@interface ZXHPictureDetailController : ZXHDetailBaseController

@property (weak, nonatomic) IBOutlet UIView *wordsView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *picCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *altLabel;
@property (weak, nonatomic) IBOutlet UIView *btnCommentsView;
@property (weak, nonatomic) IBOutlet UITextField *writeTF;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@end
