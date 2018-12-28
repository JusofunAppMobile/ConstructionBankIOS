//
//  CompanyListModel.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/27.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyListModel : NSObject

@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *companyId;
@property (nonatomic ,copy) NSString *distance;
@property (nonatomic ,copy) NSString *address;
@property (nonatomic ,copy) NSString *longitude;
@property (nonatomic ,copy) NSString *latitude;
@property (nonatomic ,copy) NSString *industry;//行业
@property (nonatomic ,copy) NSString *province;
@property (nonatomic ,copy) NSString *registMoney;
@property (nonatomic ,copy) NSString *legal;
@property (nonatomic ,copy) NSString *registDate;
@property (nonatomic ,copy) NSString *followState;
@property (nonatomic ,copy) NSString *classify;
@property (nonatomic ,copy) NSString *type;
@end
