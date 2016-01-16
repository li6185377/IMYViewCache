//
//  IMYViewCacheManager.m
//  IMYViewCache
//
//  Created by ljh on 15/12/5.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "IMYViewCacheManager.h"
#import "IMYViewCache.h"

@interface UIView (IMYViewCacheSwizzle)
+ (void)imy_registerSwizzleViewCache;
@end

@interface IMYViewCacheManager ()
@property (strong, nonatomic) NSMutableArray* viewCachArray;
@end

@implementation IMYViewCacheManager
+(instancetype)shareInstance
{
    static id instance = nil;
    if (instance) {
        return instance;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [(id)self alloc];
        instance = [instance init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewCachArray = [NSMutableArray array];
        [UIView imy_registerSwizzleViewCache];
    }
    return self;
}

- (IMYViewCacheRegisterInfo*)registerClass:(Class)viewClass
{
    IMYViewCacheRegisterInfo* info = [[IMYViewCacheRegisterInfo alloc] init];
    info.viewClass = viewClass;

    NSString* viewString = NSStringFromClass(viewClass);
    NSString* xibPath = [[NSBundle mainBundle] pathForResource:viewString ofType:@"nib"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:xibPath]) {
        UINib* nib = [UINib nibWithNibName:viewString bundle:[NSBundle mainBundle]];
        info.nib = nib;
    }
    [self registerViewInfo:info];
    return info;
}
- (IMYViewCacheRegisterInfo*)registerClass:(Class)viewClass fromNib:(UINib*)nib
{
    IMYViewCacheRegisterInfo* info = [[IMYViewCacheRegisterInfo alloc] init];
    info.viewClass = viewClass;
    info.nib = nib;

    [self registerViewInfo:info];
    return info;
}
- (IMYViewCacheRegisterInfo*)registerClass:(Class)viewClass fromNib:(UINib*)nib reuseIdentifier:(NSString*)reuseIdentifier maxCount:(NSInteger)maxCount
{
    IMYViewCacheRegisterInfo* info = [[IMYViewCacheRegisterInfo alloc] init];
    info.viewClass = viewClass;
    info.nib = nib;
    info.reuseIdentifier = reuseIdentifier;
    info.maxCount = maxCount;
    
    [self registerViewInfo:info];
    return info;
}
- (IMYViewCache*)getViewCacheForClass:(Class)viewClass reuseIdentifier:(NSString*)reuseIdentifier
{
    if (viewClass == nil && reuseIdentifier.length == 0) {
        return nil;
    }
    __block IMYViewCache* resultViewCache = nil;
    @synchronized(self) {
        [self.viewCachArray enumerateObjectsUsingBlock:^(IMYViewCache* viewCache, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL finded = YES;
            if (viewClass) {
                finded = (viewCache.viewInfo.viewClass == viewClass);
            }
            if (reuseIdentifier.length > 0) {
                finded = ([viewCache.viewInfo.reuseIdentifier isEqualToString:reuseIdentifier]);
            }
            if (finded) {
                resultViewCache = viewCache;
                *stop = YES;
            }
        }];
    }
    return resultViewCache;
}
- (void)registerViewInfo:(IMYViewCacheRegisterInfo*)info
{
    if (info.viewClass == nil) {
        NSAssert(NO, @"类形不能为空");
        return;
    }
    IMYViewCache* viewCache = [self getViewCacheForClass:info.viewClass reuseIdentifier:info.reuseIdentifier];

    if (viewCache) {
        NSAssert(NO, @"已经注册过该Class了");
        return;
    }
    viewCache = [[IMYViewCache alloc] init];
    viewCache.viewInfo = info;
    @synchronized(self) {
        viewCache.afterDelay = self.viewCachArray.count * 0.5;
        [self.viewCachArray addObject:viewCache];
    }
    [viewCache prepareLoadViewCache];
}

- (id)instanceForClass:(Class)viewClass
{
    IMYViewCache* viewCache = [self getViewCacheForClass:viewClass reuseIdentifier:nil];
    id cell = [viewCache getViewInstance];
    return cell;
}
- (id)instanceForClass:(Class)viewClass tableView:(UITableView*)tableView
{
    IMYViewCache* viewCache = [self getViewCacheForClass:viewClass reuseIdentifier:nil];
    id cell = [tableView dequeueReusableCellWithIdentifier:viewCache.viewInfo.reuseIdentifier];
    if (cell) {
        return cell;
    }
    cell = [viewCache getViewInstance];
    return cell;
}
- (id)instanceForClass:(Class)viewClass tableView:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier
{
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell) {
        return cell;
    }
    IMYViewCache* viewCache = [self getViewCacheForClass:viewClass reuseIdentifier:reuseIdentifier];
    cell = [viewCache getViewInstance];
    return cell;
}

- (void)willMoveToSuperview:(UIView*)newSuperview fromView:(UIView*)view
{
    @synchronized(self) {
        [self.viewCachArray enumerateObjectsUsingBlock:^(IMYViewCache* viewCache, NSUInteger idx, BOOL * _Nonnull stop) {
            [viewCache willMoveToSuperview:newSuperview fromView:view];
        }];
    }
}
@end