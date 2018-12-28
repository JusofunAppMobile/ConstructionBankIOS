//
//  CalendarMonthModel.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CalendarMonthModel.h"
#import "CalendarDayModel.h"
@implementation CalendarMonthModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"date":CalendarDayModel.class};
}

@end
