//
//  CalendarDayModel.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CalendarDayModel.h"

@implementation CalendarDayModel

- (int)pointNum{
    int sum = 0;
    if (_statusPhone.boolValue) {
        sum++;
    }
    if (_statusVisit.boolValue) {
        sum++;
    }
    if (_statusVisited.boolValue) {
        sum++;
    }
    if (_statusCooperation.boolValue) {
        sum++;
    }
    if (_statusformal.boolValue) {
        sum++;
    }
    return sum;
}

@end
