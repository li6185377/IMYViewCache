//
//  IMYViewCache.m
//  IMYViewCache
//
//  Created by ljh on 15/12/7.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "IMYViewCache.h"
#import "IMYViewCacheRegisterInfo.h"

@interface NSObject (IMYViewCache)
- (CFIndex)imyviewcache_retainCount;
@end

@interface IMYViewCache ()
@property (nonatomic) NSInteger reducedCount; /**< 缩减过几次*/
@end

@implementation IMYViewCache
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}
- (void)_appDidEnterBackgroundNotification
{
    [self reduceViewCache];
}
- (void)_appDidReceiveMemoryWarningNotification
{
    if (self.viewInfo.minCount == 0) {
        [self.cacheArray removeAllObjects];
    }
    else {
        NSInteger removeCount = self.cacheArray.count - self.viewInfo.minCount;
        if (removeCount > 0) {
            [self.cacheArray removeObjectsInRange:NSMakeRange(0, removeCount)];
        }
    }
}
- (void)startClearCacheTimer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reduceViewCache) object:nil];
    [self performSelector:@selector(reduceViewCache) withObject:nil afterDelay:30];
}
- (void)reduceViewCache
{
    if (self.reducedCount >= 3) {
        [self.cacheArray removeAllObjects];
    }
    else {
        NSInteger holdCount = MAX(self.viewInfo.minCount,self.viewInfo.maxCount/2);
        NSInteger removeCount = self.cacheArray.count - holdCount;
        if (removeCount > 0) {
            [self.cacheArray removeObjectsInRange:NSMakeRange(0, removeCount)];
        }
        self.reducedCount ++;
        [self startClearCacheTimer];
    }
}
- (void)prepareLoadViewCache
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.viewInfo.maxCount == 0) {
            double delay = self.viewInfo.delay + self.afterDelay;
            [self performSelector:@selector(prepareLoadViewOne) withObject:nil afterDelay:delay inModes:@[ NSDefaultRunLoopMode ]];
        }
        else {
            for (NSInteger i = self.cacheArray.count; i < self.viewInfo.maxCount; i++) {
                double delay = self.viewInfo.delay + self.afterDelay + (i / 10.0);
                [self performSelector:@selector(prepareLoadViewOne) withObject:nil afterDelay:delay inModes:@[ NSDefaultRunLoopMode ]];
            }
        }
    });
}
- (BOOL)hasCanCachingView
{
    NSInteger count = self.cacheArray.count;
    if (count > 0 && count >= self.viewInfo.maxCount) {
        return NO;
    }
    return YES;
}
- (void)addCacheView:(UIView*)cacheView
{
    if (self.viewInfo.maxCount == 0) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        NSInteger widthCount = 1;
        if (cacheView.bounds.size.width > 0) {
            widthCount = MAX(1, MIN(2, round(screenSize.width / cacheView.bounds.size.width)));
        }
        NSInteger heightCount = [IMYViewCacheRegisterInfo defaultCacheMaxCount];
        if (cacheView.bounds.size.height > 0) {
            heightCount = MAX(1, MIN(10, round(screenSize.height / cacheView.bounds.size.height) + 2));
        }
        self.viewInfo.maxCount = widthCount * heightCount;
        self.viewInfo.delay = 0;
        self.afterDelay = 0;
        [self prepareLoadViewCache];
    }
    [self.cacheArray insertObject:cacheView atIndex:0];
    
    self.reducedCount = 0;
    [self startClearCacheTimer];
}
- (void)prepareLoadViewOne
{
    if ([self hasCanCachingView] == NO) {
        return;
    }
    UIView* preloadView = [self loadOneView];
    [self addCacheView:preloadView];
}
- (id)getViewInstance
{
    id viewInstance = self.cacheArray.lastObject;
    if (viewInstance) {
        [self.cacheArray removeLastObject];
    }
    else {
        viewInstance = [self loadOneView];
    }
    [self checkDelayViewWillDealloc:viewInstance];
    return viewInstance;
}
- (id)loadOneView
{
    UIView* preloadView = nil;
    if (self.viewInfo.createViewBlock) {
        preloadView = self.viewInfo.createViewBlock(self.viewInfo);
    }

    if (preloadView == nil && self.viewInfo.nib) {
        Class viewClass = self.viewInfo.viewClass;
        NSArray* array = [self.viewInfo.nib instantiateWithOwner:nil options:nil];
        for (UIView* subview in array) {
            if ([subview isKindOfClass:viewClass]) {
                preloadView = subview;
                break;
            }
        }
    }

    if (preloadView == nil) {
        Class viewClass = self.viewInfo.viewClass;
        preloadView = [[viewClass alloc] init];
    }

    if ([preloadView respondsToSelector:@selector(prepareForInit)]) {
        [(id)preloadView prepareForInit];
    }

    return preloadView;
}
- (void)willMoveToSuperview:(UIView*)newSuperview fromView:(UIView*)view
{
    if ([view isMemberOfClass:self.viewInfo.viewClass] == NO) {
        return;
    }

    if (newSuperview) {
        [self.cacheArray removeObject:view];
    }
    else {
        [self checkDelayViewWillDealloc:view];
    }
}
- (void)checkDelayViewWillDealloc:(UIView*)viewInstance
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger retainCount = [viewInstance imyviewcache_retainCount];
        if (retainCount == 1 && [self hasCanCachingView]) {
            if ([viewInstance respondsToSelector:@selector(prepareForReuse)]) {
                [(id)viewInstance prepareForReuse];
            }
            [self addCacheView:viewInstance];
        }
    });
}
@end

@implementation NSObject (IMYViewCache)
- (CFIndex)imyviewcache_retainCount
{
    return CFGetRetainCount((__bridge CFTypeRef)self);
}
@end