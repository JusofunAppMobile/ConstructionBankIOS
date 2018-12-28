//
//  CompanyDetailModel.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "CompanyDetailModel.h"

@implementation CompanyDetailModel

-(NSString *)companyName
{
    if(_companyName.length == 0||[_companyName isEqualToString:@"null"]||[_companyName isEqualToString:@"NULL"]||[_companyName isEqualToString:@"<null>"]||[_companyName isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _companyName;
    }
}

-(NSString *)companyname
{
    if(_companyname.length == 0||[_companyname isEqualToString:@"null"]||[_companyname isEqualToString:@"NULL"]||[_companyname isEqualToString:@"<null>"]||[_companyname isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _companyname;
    }
}


-(NSString *)address
{
    if(_address.length == 0||[_address isEqualToString:@"null"]||[_address isEqualToString:@"NULL"]||[_address isEqualToString:@"<null>"]||[_address isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _address;
    }
}



@end
