//
//  NSDate+Tool.h
//  JIIESTCar
//
//  Created by wzh on 16/1/11.
//  Copyright © 2016年 WZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tool)

//- (NSInteger)currentWeekday:(NSDate *)_temDate;
- (NSDateComponents *)components;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)year;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)firstWeekdayInThisMonth;
- (NSInteger)lastWeekdayInMouth;
- (NSInteger)totaldaysInThisMonth;
- (NSInteger)totaldaysInMonth;
- (NSDate *)lastMonth;
- (NSDate *)nextMonth;
- (NSInteger)currentWeekday;
- (NSDate *)nextDay;
- (NSDate *)lastDay;
- (NSDate *)getLocalDate;
- (NSInteger)getDaysFromDate:(NSDate *)endDate;
- (NSInteger)getDaysFromDateInMinute:(NSDate *)endDate;
- (NSDate *)getLastDayInMonth;
- (NSDate *)nextDay:(NSInteger)count;
- (NSDate *)lastDay:(NSInteger)count;
- (NSComparisonResult)compareDayToDate:(NSDate *)endDate;
- (NSDate *)getLastDayInYear;
- (NSDate *)nextYear;
- (NSDate *)lastYear;
- (CGFloat)getHoursFromDate:(NSDate *)endDate;
- (NSDate *)dateAfterHour:(NSInteger)hour;
+ (BOOL)isDateToday:(NSDate *)date;
- (NSInteger)getMonthIntervalFromDate:(NSDate *)endDate;
- (NSDate *)nextYearWithMonth:(int)month;
//- (NSDate *)firstDayInMonth;

@end
