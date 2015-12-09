//
//  IMYEBBrandSingleCell.m
//  IMY_EBusiness
//
//  Created by ljh on 15/5/22.
//  Copyright (c) 2015年 IMY. All rights reserved.
//

#import "IMYEBBrandSingleCell.h"

@interface IMYEBBrandSingleCell()
@end

@implementation IMYEBBrandSingleCell
///初始化回调
-(void)prepareForInit
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [IMYEBBrandSingleCell cellHeight]);
}
///复用回调
-(void)prepareForReuse
{
    [super prepareForReuse];
    ///没啥事干
    ///如果是 cell  一定要调用 super
    ///you must be sure to invoke the superclass implementation.
}


+(CGFloat)cellHeight
{
    return ceil(47 + 148*([UIScreen mainScreen].bounds.size.width/320.0f));
}
@end
