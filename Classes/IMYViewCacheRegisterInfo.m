//
//  IMYViewCacheRegisterInfo.m
//  IMYViewCache
//
//  Created by ljh on 15/12/5.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "IMYViewCacheRegisterInfo.h"

@implementation IMYViewCacheRegisterInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        _delay = [IMYViewCacheRegisterInfo defaultPreloadingDelay];
    }
    return self;
}

- (NSString *)reuseIdentifier {
    if (_reuseIdentifier == nil && _viewClass) {
        _reuseIdentifier = NSStringFromClass(_viewClass);
    }
    return _reuseIdentifier;
}

+ (NSInteger)defaultCacheMaxCount {
    return 1;
}

+ (double)defaultPreloadingDelay {
    return 10;
}

@end
