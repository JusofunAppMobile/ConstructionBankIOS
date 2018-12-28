//
//  UserCenterCell.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterCell : UITableViewCell
@property (nonatomic ,assign) NSInteger row;

@property (nonatomic ,strong) UIImageView *iconView;
@property (nonatomic ,strong) UILabel *titleLab;
@end
