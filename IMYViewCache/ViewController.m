//
//  ViewController.m
//  IMYViewCache
//
//  Created by ljh on 15/12/7.
//  Copyright © 2015年 IMY. All rights reserved.
//

#import "ViewController.h"
#import "IMYDemoVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)bt_action_nocache:(id)sender {
    IMYDemoVC* vc = [[IMYDemoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)bt_action_usingCache:(id)sender {
    IMYDemoVC* vc = [[IMYDemoVC alloc] init];
    vc.isUsingCache = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
