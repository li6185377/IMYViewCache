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
@interface IMYViewCache : NSObject

@property (strong, nonatomic) IMYViewCacheRegisterInfo* viewInfo;
@property (strong, nonatomic) NSMutableArray* cacheArray;
@property (nonatomic) double afterDelay; ///每个viewCache加载的间隔 由manager提供
///返回一个 view  实例
- (id)getViewInstance;

///开始预加载 viewCache
- (void)prepareLoadViewCache;
- (void)willMoveToSuperview:(UIView*)newSuperview fromView:(UIView*)view;
@end