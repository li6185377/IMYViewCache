//
//  UITableView+IMYViewCache.m
//  IMYViewCache
//
//  Created by ljh on 15/12/8.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "IMYViewCacheManager.h"
#import "UITableView+IMYViewCache.h"

@implementation UITableView (IMYViewCache)

- (BOOL)imy_usingViewCache {
    return NO;
}

- (void)setImy_usingViewCache:(BOOL)usingViewCache {
    if (!usingViewCache) {
        return;
    }
    NSArray *array = [IMYViewCacheManager shareInstance].viewCachArray;
    for (IMYViewCache *cache in array) {
        IMYViewCacheRegisterInfo *info = cache.viewInfo;
        if (!info.reuseIdentifier) {
            continue;
        }
        if (info.nib) {
            [self registerNib:info.nib forCellReuseIdentifier:info.reuseIdentifier];
        } else {
            [self registerClass:info.viewClass forCellReuseIdentifier:info.reuseIdentifier];
        }
    }
}

+ (void)imy_registerClass:(Class)cellClass nib:(UINib *)nib reuseIdentifier:(NSString *)identifier cacheCount:(NSInteger)cacheCount {
    [[IMYViewCacheManager shareInstance] registerClass:cellClass fromNib:nib reuseIdentifier:identifier maxCount:cacheCount];
}

+ (BOOL)imy_hasRegistedClass:(Class)cellClass nib:(UINib *)nib reuseIdentifier:(NSString *)identifier {
    return ([[IMYViewCacheManager shareInstance] getViewCacheForClass:cellClass reuseIdentifier:identifier] != nil);
}

+ (UITableViewCell *)imy_dequeueReusableCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier {
    return [[IMYViewCacheManager shareInstance] instanceForClass:nil tableView:tableView reuseIdentifier:identifier];
}

@end
