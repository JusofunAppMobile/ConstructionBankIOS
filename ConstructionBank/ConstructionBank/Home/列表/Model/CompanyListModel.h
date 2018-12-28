//
//  CompanyListModel.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/27.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyListModel : NSObject

@property (nonatomic ,copy) NSString *companyName;
@property (nonatomic ,copy) NSString *industry;
@property (nonatomic ,copy) NSString *city;
@property (nonatomic ,copy) NSString *money;
@property (nonatomic ,copy) NSString *legalPerson;
@property (nonatomic ,copy) NSString *date;

@property (nonatomic ,copy) NSString *distance;
@property (nonatomic ,copy) NSString *address;

@end
