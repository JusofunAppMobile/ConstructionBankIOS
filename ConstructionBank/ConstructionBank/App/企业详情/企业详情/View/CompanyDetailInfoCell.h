//
//  CompanyDetailInfoCell.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompanyDetailModel;

@interface CompanyDetailInfoCell : UITableViewCell

@property (nonatomic ,strong) UIButton *recordBtn;

- (void)setModel:(CompanyDetailModel *)model type:(NSInteger)companyType;

@end
