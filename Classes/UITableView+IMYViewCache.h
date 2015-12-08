//
//  UITableView+IMYViewCache.h
//  IMYViewCache
//
//  Created by ljh on 15/12/8.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (IMYViewCache)
///注册全局的 TableViewCell
+ (void)imy_registerClass:(Class)cellClass nib:(UINib*)nib reuseIdentifier:(NSString*)identifier cacheCount:(NSInteger)cacheCount;
///获取全局注册的 Cell
+ (UITableViewCell*)imy_dequeueReusableCellWithTableView:(UITableView*)tableView reuseIdentifier:(NSString*)identifier;
@end
