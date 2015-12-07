//
//  IMYViewCacheManager.h
//  IMYViewCache
//
//  Created by ljh on 15/12/5.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMYViewCacheRegisterInfo.h"

@interface IMYViewCacheManager : NSObject

+ (instancetype)shareInstance;

- (IMYViewCacheRegisterInfo*)registerClass:(Class)viewClass;
- (IMYViewCacheRegisterInfo*)registerClass:(Class)viewClass fromNib:(UINib*)nib;
- (void)registerViewInfo:(IMYViewCacheRegisterInfo*)info;

- (id)instanceForClass:(Class)viewClass;
- (id)instanceForClass:(Class)viewClass tableView:(UITableView*)tableView;

@end

@interface IMYViewCacheManager (IMY_UNAVAILABLE_ATTRIBUTE)
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype) new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)alloc UNAVAILABLE_ATTRIBUTE;
@end