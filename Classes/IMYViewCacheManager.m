//
//  IMYViewCacheManager.m
//  IMYViewCache
//
//  Created by ljh on 15/12/5.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "IMYViewCacheManager.h"
#import "IMYViewCache.h"
#import <objc/runtime.h>

@interface UIView (IMYViewCache)
+ (void)imy_registerSwizzleViewCache;
@end

@interface IMYViewCacheManager ()
@property (strong, nonatomic) NSMutableArray* viewCachArray;
- (void)willMoveToSuperview:(UIView*)newSuperview fromView:(UIView*)view;
@end

@implementation IMYViewCacheManager
+ (instancetype)shareInstance
{
    static IMYViewCacheManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super new];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [UIView imy_registerSwizzleViewCache];
        self.viewCachArray = [NSMutableArray array];
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
    for (int i = 0; i < _viewCachArray.count; i++) {
        IMYViewCache* viewCache = [_viewCachArray objectAtIndex:i];
        BOOL finded = YES;
        if (viewClass) {
            finded = (viewCache.viewInfo.viewClass == viewClass);
        }
        if (reuseIdentifier.length > 0) {
            finded = ([viewCache.viewInfo.reuseIdentifier isEqualToString:reuseIdentifier]);
        }
        if (finded) {
            return viewCache;
        }
    }
    return nil;
}
- (void)registerViewInfo:(IMYViewCacheRegisterInfo*)info
{
    if (info.viewClass == nil) {
        NSAssert(NO, @"类名不能为空");
        return;
    }
    IMYViewCache* viewCache = [self getViewCacheForClass:info.viewClass reuseIdentifier:info.reuseIdentifier];

    if (viewCache) {
        NSAssert(NO, @"已经注册过该Class了");
        return;
    }
    viewCache = [[IMYViewCache alloc] init];
    viewCache.viewInfo = info;
    viewCache.afterDelay = self.viewCachArray.count * 0.5;

    [self.viewCachArray addObject:viewCache];
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
    if (self.viewCachArray.count == 0) {
        return;
    }

    for (int i = 0; i < _viewCachArray.count; i++) {
        IMYViewCache* viewCache = [_viewCachArray objectAtIndex:i];
        [viewCache willMoveToSuperview:newSuperview fromView:view];
    }
}
@end

@implementation UIView (IMYViewCache)
+ (BOOL)imy_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_
{
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        return NO;
    }
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if (!altMethod) {
        return NO;
    }

    class_addMethod(self,
        origSel_,
        class_getMethodImplementation(self, origSel_),
        method_getTypeEncoding(origMethod));
    class_addMethod(self,
        altSel_,
        class_getMethodImplementation(self, altSel_),
        method_getTypeEncoding(altMethod));

    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));

    return YES;
}
+ (void)imy_registerSwizzleViewCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIView imy_swizzleMethod:@selector(willMoveToSuperview:) withMethod:@selector(imyviewcache_willMoveToSuperview:) error:nil];
    });
}
- (void)imyviewcache_willMoveToSuperview:(UIView*)newSuperview
{
    [self imyviewcache_willMoveToSuperview:newSuperview];
    [[IMYViewCacheManager shareInstance] willMoveToSuperview:newSuperview fromView:self];
}
@end