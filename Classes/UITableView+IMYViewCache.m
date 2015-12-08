//
//  UITableView+IMYViewCache.m
//  IMYViewCache
//
//  Created by ljh on 15/12/8.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "UITableView+IMYViewCache.h"
#import "IMYViewCacheManager.h"
#import <objc/runtime.h>

@implementation UITableView (IMYViewCache)
static const void *IMYUsingViewCacheKey = &IMYUsingViewCacheKey;
-(BOOL)imy_usingViewCache
{
    return [objc_getAssociatedObject(self, IMYUsingViewCacheKey) boolValue];
}
-(void)setImy_usingViewCache:(BOOL)imy_usingViewCache
{
    if (imy_usingViewCache) {
        objc_setAssociatedObject(self, IMYUsingViewCacheKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        objc_setAssociatedObject(self, IMYUsingViewCacheKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
+(void)imy_registerClass:(Class)cellClass nib:(UINib *)nib reuseIdentifier:(NSString *)identifier cacheCount:(NSInteger)cacheCount
{
    [[IMYViewCacheManager shareInstance] registerClass:cellClass fromNib:nib reuseIdentifier:identifier maxCount:cacheCount];
}
+(BOOL)imy_hasRegistedClass:(Class)cellClass nib:(UINib *)nib reuseIdentifier:(NSString *)identifier
{
   return ([[IMYViewCacheManager shareInstance] getViewCacheForClass:cellClass reuseIdentifier:identifier] != nil);
}
+(UITableViewCell *)imy_dequeueReusableCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier
{
    return [[IMYViewCacheManager shareInstance] instanceForClass:nil tableView:tableView reuseIdentifier:identifier];
}
-(UITableViewCell *)imyviewcache_dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier
{
    id cell = [self imyviewcache_dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil && self.imy_usingViewCache) {
        IMYViewCache* viewCache = [[IMYViewCacheManager shareInstance] getViewCacheForClass:nil reuseIdentifier:reuseIdentifier];
        cell = [viewCache getViewInstance];
    }
    return cell;
}
@end

@interface IMYViewCacheManager (IMYSuperViewChangedDelegate)
- (void)willMoveToSuperview:(UIView*)newSuperview fromView:(UIView*)view;
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
        [UITableView imy_swizzleMethod:@selector(dequeueReusableCellWithIdentifier:) withMethod:@selector(imyviewcache_dequeueReusableCellWithIdentifier:) error:nil];
    });
}
- (void)imyviewcache_willMoveToSuperview:(UIView*)newSuperview
{
    [self imyviewcache_willMoveToSuperview:newSuperview];
    [[IMYViewCacheManager shareInstance] willMoveToSuperview:newSuperview fromView:self];
}
@end