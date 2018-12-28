//
//  CompanyDetailModel.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyDetailModel : NSObject

//公司名
@property (nonatomic ,copy) NSString *address;
@property (nonatomic ,copy) NSString *companyName;
@property (nonatomic ,copy) NSString *companyname;
@property (nonatomic ,copy) NSString *distance;
@property (nonatomic ,copy) NSString *followState;//跟进状态
@property (nonatomic ,copy) NSString *longitude;//经度
@property (nonatomic ,copy) NSString *latitude;//纬度
@property (nonatomic ,copy) NSString *classify;
@property (nonatomic ,copy) NSString *type;//企业类型

//联系方式
@property (nonatomic,strong) NSArray *contactinformation;
//网址
@property (nonatomic,strong) NSArray *neturl;

//九宫格详细内容
@property (nonatomic,strong) NSArray *subclassMenu;


@property (nonatomic ,copy) NSString *companyid;
@property (nonatomic ,copy) NSString *legal;
@property (nonatomic ,copy) NSString *companystate;
//联系方式
@property (nonatomic,strong) NSArray *companyphonelist;

@end
