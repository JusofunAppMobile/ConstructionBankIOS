//
//  DetailMapController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/7.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "CompanyMap.h"
#import "CompanyMapModel.h"
#import "CompanyMapController.h"
@interface DetailMapController : BasicViewController<CompanyDelegate>


@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong) NSString *companyName;


@end
