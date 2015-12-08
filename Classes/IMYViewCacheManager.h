//
//  IMYViewCacheManager.h
//  IMYViewCache
//
//  Created by ljh on 15/12/5.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMYViewCacheRegisterInfo.h"
#import "IMYViewCache.h"

@interface IMYViewCacheManager : NSObject

+ (instancetype)shareInstance;

- (IMYViewCacheRegisterInfo*)registerClass:(Class)viewClass;
- (IMYViewCacheRegisterInfo*)registerClass:(Class)viewClass fromNib:(UINib*)nib;
- (IMYViewCacheRegisterInfo*)registerClass:(Class)viewClass fromNib:(UINib*)nib reuseIdentifier:(NSString*)reuseIdentifier maxCount:(NSInteger)maxCount;
- (void)registerViewInfo:(IMYViewCacheRegisterInfo*)info;

- (id)instanceForClass:(Class)viewClass;
- (id)instanceForClass:(Class)viewClass tableView:(UITableView*)tableView;
- (id)instanceForClass:(Class)viewClass tableView:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier;

- (IMYViewCache*)getViewCacheForClass:(Class)viewClass reuseIdentifier:(NSString*)reuseIdentifier;

@end

@interface IMYViewCacheManager (IMY_UNAVAILABLE_ATTRIBUTE)
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype) new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)alloc UNAVAILABLE_ATTRIBUTE;
@end