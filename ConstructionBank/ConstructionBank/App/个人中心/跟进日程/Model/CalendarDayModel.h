//
//  CalendarDayModel.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarDayModel : NSObject

@property (nonatomic ,copy) NSString *day;
@property (nonatomic ,copy) NSString *statusPhone;
@property (nonatomic ,copy) NSString *statusVisit;
@property (nonatomic ,copy) NSString *statusVisited;
@property (nonatomic ,copy) NSString *statusCooperation;
@property (nonatomic ,copy) NSString *statusformal;
@property (nonatomic ,assign) BOOL select;
@property (nonatomic ,assign) int pointNum;
@end
