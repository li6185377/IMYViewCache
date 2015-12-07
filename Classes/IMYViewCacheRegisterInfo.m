//
//  IMYViewCacheRegisterInfo.m
//  IMYViewCache
//
//  Created by ljh on 15/12/5.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "IMYViewCacheRegisterInfo.h"

@implementation IMYViewCacheRegisterInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delay = [IMYViewCacheRegisterInfo defaultPreloadingDelay];
    }
    return self;
}
- (NSString*)reuseIdentifier
{
    if (_reuseIdentifier == nil && _viewClass) {
        _reuseIdentifier = NSStringFromClass(_viewClass);
    }
    return _reuseIdentifier;
}
+ (NSInteger)defaultCacheMaxCount
{
    double screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight < 500) {
        ///iphone 4,4s
        return 4;
    }
    if (screenHeight == 568) {
        ///iphone 5,5s
        return 6;
    }
    ///iphone 6,6+
    return 8;
}
+ (double)defaultPreloadingDelay
{
    double screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight < 500) {
        ///iphone 4,4s
        return 9;
    }
    if (screenHeight == 568) {
        ///iphone 5,5s
        return 6;
    }
    ///iphone 6,6+
    return 3;
}
@end
