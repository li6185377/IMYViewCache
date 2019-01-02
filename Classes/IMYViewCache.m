//
//  IMYViewCache.m
//  IMYViewCache
//
//  Created by ljh on 15/12/7.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "IMYViewCache.h"
#import "IMYViewCacheRegisterInfo.h"

@implementation IMYViewCache

- (void)prepareLoadViewCache {
}

- (id)getViewInstance {
    return [self loadOneView];
}

- (id)loadOneView {
    UIView *preloadView = nil;
    if (self.viewInfo.createViewBlock) {
        preloadView = self.viewInfo.createViewBlock(self.viewInfo);
    }

    if (!preloadView && self.viewInfo.nib) {
        Class viewClass = self.viewInfo.viewClass;
        NSArray *array = [self.viewInfo.nib instantiateWithOwner:nil options:nil];
        for (UIView *subview in array) {
            if ([subview isKindOfClass:viewClass]) {
                preloadView = subview;
                break;
            }
        }
    }

    if (!preloadView) {
        Class viewClass = self.viewInfo.viewClass;
        preloadView = [[viewClass alloc] init];
    }

    if ([preloadView respondsToSelector:@selector(prepareForInit)]) {
        [(id)preloadView prepareForInit];
    }

    return preloadView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview fromView:(UIView *)view {
}

@end
