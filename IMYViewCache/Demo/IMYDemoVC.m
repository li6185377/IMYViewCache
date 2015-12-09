//
//  IMYDemoVC.m
//  IMYViewCache
//
//  Created by ljh on 15/12/7.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "IMYDemoVC.h"
#import "IMYEBBrandSingleCell.h"
#import "IMYViewCacheManager.h"
#import "UITableView+IMYViewCache.h"

@interface IMYDemoVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation IMYDemoVC
+(void)load
{
    ///max count = 0 会自动计算 一屏幕高度下 可以放多少个cell
    [UITableView imy_registerClass:[IMYEBBrandSingleCell class] nib:[UINib nibWithNibName:@"IMYEBBrandSingleCell" bundle:nil] reuseIdentifier:@"IMYEBBrandSingleCell" cacheCount:8];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.imy_usingViewCache = _isUsingCache;
    [self.view addSubview:tableView];
    
    if (_isUsingCache == NO) {
        [tableView registerNib:[UINib nibWithNibName:@"IMYEBBrandSingleCell" bundle:nil] forCellReuseIdentifier:@"IMYEBBrandSingleCell"];
    }
    else {
        tableView.imy_usingViewCache = YES;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSTimeInterval startLoadTime = [[NSDate date] timeIntervalSince1970];
    IMYEBBrandSingleCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IMYEBBrandSingleCell"];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",indexPath];
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"cell %@ ,加载时间:%lf",indexPath,endTime - startLoadTime);
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [IMYEBBrandSingleCell cellHeight];
}
@end
