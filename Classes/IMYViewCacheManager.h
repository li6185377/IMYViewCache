//
//  IMYViewCacheManager.h
//  IMYViewCache
//
//  Created by ljh on 15/12/5.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "IMYViewCache.h"
#import "IMYViewCacheRegisterInfo.h"
#import <Foundation/Foundation.h>

NS_CLASS_DEPRECATED_IOS(1_0, 1_0, "IMYViewCache has been deprecated!")
@interface IMYViewCacheManager : NSObject

+ (instancetype)shareInstance;

@property (atomic, copy, readonly) NSArray<IMYViewCache *> *viewCachArray;

- (IMYViewCacheRegisterInfo *)registerClass:(Class)viewClass;
- (IMYViewCacheRegisterInfo *)registerClass:(Class)viewClass fromNib:(UINib *)nib;
- (IMYViewCacheRegisterInfo *)registerClass:(Class)viewClass fromNib:(UINib *)nib reuseIdentifier:(NSString *)reuseIdentifier maxCount:(NSInteger)maxCount;

- (void)registerViewInfo:(IMYViewCacheRegisterInfo *)info;

- (id)instanceForClass:(Class)viewClass;
- (id)instanceForClass:(Class)viewClass tableView:(UITableView *)tableView;
- (id)instanceForClass:(Class)viewClass tableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

- (IMYViewCache *)getViewCacheForClass:(Class)viewClass reuseIdentifier:(NSString *)reuseIdentifier;

@end
