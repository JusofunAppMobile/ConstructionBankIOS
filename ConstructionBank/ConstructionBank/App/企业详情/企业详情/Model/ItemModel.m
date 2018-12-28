//
//  ItemModel.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

+ (NSDictionary *)objectClassInArray
{
    return@{
            @"tablist" :TabListModel.class,
            };
}

@end
