//
//  IMYEBBrandSingleCell.h
//  IMY_EBusiness
//
//  Created by ljh on 15/5/22.
//  Copyright (c) 2015年 IMY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMYViewCacheManager.h"

@interface IMYEBBrandSingleCell : UITableViewCell <IMYViewCacheReuseProtocol>

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *moodsButton;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet UIImageView *custonTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *customTagLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTitleLayoutConstraint;

+(CGFloat)cellHeight;

@end
