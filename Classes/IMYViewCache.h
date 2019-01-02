//
//  IMYViewCache.h
//  IMYViewCache
//
//  Created by ljh on 15/12/7.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMYViewCacheRegisterInfo;
///请使用ViewCacheManager 来管理view的缓存
NS_CLASS_DEPRECATED_IOS(1_0, 1_0, "IMYViewCache has been deprecated!")
@interface IMYViewCache : NSObject

@property (nonatomic, strong) IMYViewCacheRegisterInfo *viewInfo;
@property (nonatomic, strong) NSMutableArray *cacheArray;
///每个viewCache加载的间隔 由manager提供
@property (nonatomic, assign) double afterDelay;
///返回一个 view  实例
- (id)getViewInstance;

///开始预加载 viewCache
- (void)prepareLoadViewCache;
- (void)willMoveToSuperview:(UIView *)newSuperview fromView:(UIView *)view;
@end
