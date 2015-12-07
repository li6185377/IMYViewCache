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
@property (strong, nonatomic) NSMutableDictionary* cacheMap;
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
        self.cacheMap = [NSMutableDictionary dictionary];
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

- (void)registerViewInfo:(IMYViewCacheRegisterInfo*)info
{
    if (info.viewClass == nil) {
        NSAssert(NO, @"类名不能为空");
        return;
    }
    NSString* cacheKey = NSStringFromClass(info.viewClass);
    IMYViewCache* viewCache = [self.cacheMap objectForKey:cacheKey];

    if (viewCache) {
        NSAssert(NO, @"已经注册过该Class了");
        return;
    }
    viewCache = [[IMYViewCache alloc] init];
    viewCache.viewInfo = info;
    viewCache.afterDelay = self.cacheMap.count * 0.5;

    [self.cacheMap setObject:viewCache forKey:cacheKey];
    [viewCache prepareLoadViewCache];
}

- (id)instanceForClass:(Class)viewClass
{
    NSString* cacheKey = NSStringFromClass(viewClass);
    IMYViewCache* viewCache = [self.cacheMap objectForKey:cacheKey];
    return [viewCache getViewInstance];
}
- (id)instanceForClass:(Class)viewClass tableView:(UITableView*)tableView
{
    NSString* cacheKey = NSStringFromClass(viewClass);
    IMYViewCache* viewCache = [self.cacheMap objectForKey:cacheKey];
    id cell = [tableView dequeueReusableCellWithIdentifier:viewCache.viewInfo.reuseIdentifier];
    if (cell) {
        return cell;
    }
    return [viewCache getViewInstance];
}

- (void)willMoveToSuperview:(UIView*)newSuperview fromView:(UIView*)view
{
    if (self.cacheMap.count == 0) {
        return;
    }

    [self.cacheMap.allValues enumerateObjectsUsingBlock:^(IMYViewCache* viewCache, NSUInteger idx, BOOL* stop) {
        [viewCache willMoveToSuperview:newSuperview fromView:view];
    }];
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