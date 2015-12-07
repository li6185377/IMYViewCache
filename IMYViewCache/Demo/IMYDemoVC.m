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

@interface IMYDemoVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation IMYDemoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSTimeInterval startLoadTime = [[NSDate date] timeIntervalSince1970];
    IMYEBBrandSingleCell* cell = nil;
    if (_isUsingCache) {
        cell = [[IMYViewCacheManager shareInstance] instanceForClass:[IMYEBBrandSingleCell class] tableView:tableView];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"IMYEBBrandSingleCell"];
        if (!cell) {
           cell = [[[NSBundle mainBundle] loadNibNamed:@"IMYEBBrandSingleCell" owner:nil options:nil] lastObject];
        }
    }
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
