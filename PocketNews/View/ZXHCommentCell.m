//
//  ZXHCommentCell.m
//  PocketNews
//
//  Created by qianfeng on 15-6-29.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHCommentCell.h"


@implementation ZXHCommentCell
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.replyView.layer.borderWidth = 1;
        self.replyView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    return self;
}
@end
