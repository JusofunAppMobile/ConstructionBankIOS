//
//  CompanyMapController.h
//  EnterpriseInquiry
//
//  Created by jusfoun on 15/11/20.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "BasicViewController.h"
#import <CAAnimation+Blocks.h>
#import "ButtonModel.h"
#import "CompanyMapLeftView.h"
#import "CompanyMapModel.h"
#import "CompanyDetailController.h"
@interface CompanyMapController : BasicViewController<UIScrollViewDelegate,CompanyMapLeftViewDelegate>

@property(nonatomic,strong) NSString *entid;
@property(nonatomic,strong) NSDictionary *companyDic;

@property (nonatomic,strong) NSString *companyName;


@end
