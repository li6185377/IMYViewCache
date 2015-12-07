//
//  IMYViewCacheRegisterInfo.h
//  IMYViewCache
//
//  Created by ljh on 15/12/5.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMYViewCacheRegisterInfo : NSObject

@property (nonatomic) Class viewClass; /**< 需要缓存视图类*/
@property (nonatomic, strong) UINib* nib; /**< 从xib中加载缓存*/
@property (nonatomic, copy) NSString* reuseIdentifier; /**< 优先取tableView中的缓存*/
@property (nonatomic) NSUInteger maxCount; /**< 内存中 最大的缓存数量*/
@property (nonatomic) NSUInteger minCount; /**< 当收到内存警告时 最少的缓存保留数量 默认 0*/

@property (nonatomic) double delay; /**< 注册后 延迟多少秒预加载 view*/

@property (nonatomic, copy) UIView* (^createViewBlock)(IMYViewCacheRegisterInfo* info); /**< 由外部进行UIView 的初始化*/

+ (NSInteger)defaultCacheMaxCount;
+ (double)defaultPreloadingDelay;

@end

@protocol IMYViewCacheReuseProtocol
///初始化回调
- (void)prepareForInit;
///复用回调  做些要复用的操作
- (void)prepareForReuse;
@end