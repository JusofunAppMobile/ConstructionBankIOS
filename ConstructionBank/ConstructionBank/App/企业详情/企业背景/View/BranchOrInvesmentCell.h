//
//  BranchOrInvesmentCell.h
//  EnterpriseInquiry
//
//  Created by clj on 15/11/23.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyDetailModel.h"
@interface BranchOrInvesmentCell : UITableViewCell

@property (nonatomic,strong) UILabel *companyNameLabel;//企业名称
@property (nonatomic,strong) UILabel *legalName;//企业法人
@property (nonatomic,strong) UILabel *companyState;//企业状态
@property (nonatomic,strong) UIImageView *legalImageView;//法人的图标

@property (nonatomic,assign) int invesmentType;//1对外投资，2 分支机构

-(CGFloat)heightForCellWithText:(CompanyDetailModel *)comModel;



-(void)setHotCompanyCellFrame;
@end
