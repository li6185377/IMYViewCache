//
//  IMYViewCacheManager.m
//  IMYViewCache
//
//  Created by ljh on 15/12/5.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "IMYViewCacheManager.h"
#import "IMYViewCache.h"

@interface IMYViewCacheManager ()
@property (atomic, copy) NSArray<IMYViewCache *> *viewCachArray;
@end

@implementation IMYViewCacheManager

+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (IMYViewCacheRegisterInfo *)registerClass:(Class)viewClass {
    IMYViewCacheRegisterInfo *info = [[IMYViewCacheRegisterInfo alloc] init];
    info.viewClass = viewClass;
    NSString *viewString = NSStringFromClass(viewClass);
    NSString *xibPath = [[NSBundle mainBundle] pathForResource:viewString ofType:@"nib"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:xibPath]) {
        UINib *nib = [UINib nibWithNibName:viewString bundle:[NSBundle mainBundle]];
        info.nib = nib;
    }
    [self registerViewInfo:info];
    return info;
}

- (IMYViewCacheRegisterInfo *)registerClass:(Class)viewClass fromNib:(UINib *)nib {
    IMYViewCacheRegisterInfo *info = [[IMYViewCacheRegisterInfo alloc] init];
    info.viewClass = viewClass;
    info.nib = nib;
    [self registerViewInfo:info];
    return info;
}

- (IMYViewCacheRegisterInfo *)registerClass:(Class)viewClass fromNib:(UINib *)nib reuseIdentifier:(NSString *)reuseIdentifier maxCount:(NSInteger)maxCount {
    IMYViewCacheRegisterInfo *info = [[IMYViewCacheRegisterInfo alloc] init];
    info.viewClass = viewClass;
    info.nib = nib;
    info.reuseIdentifier = reuseIdentifier;
    info.maxCount = maxCount;
    [self registerViewInfo:info];
    return info;
}

- (IMYViewCache *)getViewCacheForClass:(Class)viewClass reuseIdentifier:(NSString *)reuseIdentifier {
    if (!viewClass && reuseIdentifier.length == 0) {
        return nil;
    }
    IMYViewCache *resultViewCache = nil;
    NSArray *array = self.viewCachArray;
    for (IMYViewCache *viewCache in array) {
        if (reuseIdentifier.length > 0 && [viewCache.viewInfo.reuseIdentifier isEqualToString:reuseIdentifier]) {
            resultViewCache = viewCache;
            break;
        }
        if (viewClass && viewCache.viewInfo.viewClass == viewClass) {
            resultViewCache = viewCache;
            break;
        }
    }
    return resultViewCache;
}

- (void)registerViewInfo:(IMYViewCacheRegisterInfo *)info {
    if (!info.viewClass) {
        NSAssert(NO, @"类形不能为空");
        return;
    }
    IMYViewCache *viewCache = [self getViewCacheForClass:info.viewClass reuseIdentifier:info.reuseIdentifier];
    if (viewCache) {
        NSAssert(NO, @"已经注册过该Class了");
        return;
    }
    
    viewCache = [[IMYViewCache alloc] init];
    viewCache.viewInfo = info;
    __block NSArray *oldArray = self.viewCachArray;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:oldArray];
    [mutableArray addObject:viewCache];
    self.viewCachArray = mutableArray;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        oldArray = nil;
    });
}

- (id)instanceForClass:(Class)viewClass {
    IMYViewCache *viewCache = [self getViewCacheForClass:viewClass reuseIdentifier:nil];
    id cell = [viewCache getViewInstance];
    return cell;
}

- (id)instanceForClass:(Class)viewClass tableView:(UITableView *)tableView {
    IMYViewCache *viewCache = [self getViewCacheForClass:viewClass reuseIdentifier:nil];
    id cell = [tableView dequeueReusableCellWithIdentifier:viewCache.viewInfo.reuseIdentifier];
    if (cell) {
        return cell;
    }
    cell = [viewCache getViewInstance];
    return cell;
}

- (id)instanceForClass:(Class)viewClass tableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell) {
        return cell;
    }
    IMYViewCache *viewCache = [self getViewCacheForClass:viewClass reuseIdentifier:reuseIdentifier];
    cell = [viewCache getViewInstance];
    return cell;
}

@end
