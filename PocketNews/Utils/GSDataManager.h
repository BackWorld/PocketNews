//
//  GSDataManager.h
//  GlassesStore
//
//  Created by MS on 15-6-21.
//  Copyright (c) 2015年 CS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSDataManager : NSObject

+(GSDataManager*)defaultManager;
-(void)loadWebDataWithUrl:(NSString*)strUrl;

@property(nonatomic,copy)void(^passData)(NSData *data);

@end
