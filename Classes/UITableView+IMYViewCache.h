//
//  UITableView+IMYViewCache.h
//  IMYViewCache
//
//  Created by ljh on 15/12/8.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (IMYViewCache)

///如果设为YES 则 实例调用 dequeueReusable 也会走 IMYViewCache 的方法
@property (nonatomic, assign) BOOL imy_usingViewCache __deprecated_msg("IMYViewCache has been deprecated!");

///注册全局的 TableViewCell
+ (void)imy_registerClass:(Class)cellClass nib:(UINib *)nib reuseIdentifier:(NSString *)identifier cacheCount:(NSInteger)cacheCount __deprecated_msg("IMYViewCache has been deprecated!");

///是否已经注册了全局cell cache
+ (BOOL)imy_hasRegistedClass:(Class)cellClass nib:(UINib *)nib reuseIdentifier:(NSString *)identifier __deprecated_msg("IMYViewCache has been deprecated!");

///获取全局注册的 Cell
+ (UITableViewCell *)imy_dequeueReusableCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier __deprecated_msg("IMYViewCache has been deprecated!");

@end
