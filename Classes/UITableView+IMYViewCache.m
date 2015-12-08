//
//  UITableView+IMYViewCache.m
//  IMYViewCache
//
//  Created by ljh on 15/12/8.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "UITableView+IMYViewCache.h"
#import "IMYViewCacheManager.h"

@implementation UITableView (IMYViewCache)
+(void)imy_registerClass:(Class)cellClass nib:(UINib *)nib reuseIdentifier:(NSString *)identifier cacheCount:(NSInteger)cacheCount
{
    [[IMYViewCacheManager shareInstance] registerClass:cellClass fromNib:nib reuseIdentifier:identifier maxCount:cacheCount];
}
+(UITableViewCell *)imy_dequeueReusableCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier
{
    return [[IMYViewCacheManager shareInstance] instanceForClass:nil tableView:tableView reuseIdentifier:identifier];
}
@end
