//
//  ZXHNewsCommenModel.m
//  PocketNews
//
//  Created by MS on 15-6-25.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "ZXHNewsCommenModel.h"

@implementation ZXHNewsCommenModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.newsid = value;
    }
}

@end
