//
//  CompanyListModel.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/27.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CompanyListModel.h"

@implementation CompanyListModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"industry":@"nature",@"companyId":@"entid"};
}

@end
