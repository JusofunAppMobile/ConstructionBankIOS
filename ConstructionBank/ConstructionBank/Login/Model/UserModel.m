//
//  UserModel.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
SingletonM(User);

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"userID" : @"id"
            
             };
}

-(NSString *)userID
{
    if(_userID == nil)
    {
        return @"";
    }
    else
    {

        return _userID;//
    }
}

@end
