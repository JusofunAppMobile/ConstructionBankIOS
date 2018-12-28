//
//  NSDate+Tool.m
//  JIIESTCar
//
//  Created by wzh on 16/1/11.
//  Copyright © 2016年 WZH. All rights reserved.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)

#pragma mark - date

- (NSDate *)getLastDayInYear{
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    BOOL result = [[NSCalendar currentCalendar] rangeOfUnit:NSYearCalendarUnit startDate:&beginDate interval:&interval forDate:self];
    
    if (result) {
        endDate=[beginDate dateByAddingTimeInterval:interval-1];
    }
    return endDate;
    
}
- (NSDate *)getLastDayInMonth
{
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    BOOL result = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:self];
    
    if (result) {
        endDate=[beginDate dateByAddingTimeInterval:interval-1];
    }
    return endDate;
}

- (NSInteger)hour{
    NSDateComponents *com = [self components];
    return com.hour;
}

- (NSInteger)minute{
    NSDateComponents *com = [self components];
    return com.minute;
}

- (NSDateComponents *)components
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:self];
    return components;
    
}
- (NSInteger)day{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [components day];
}


- (NSInteger)month{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [components month];
}

- (NSInteger)year{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    [comp setDay:1];
    
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    
    return firstWeekday - 1;
}
-(NSInteger)lastWeekdayInMouth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    [comp setDay:[self totaldaysInMonth]];
    
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger lastWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    
    return lastWeekday - 1;
    
}

- (NSInteger)totaldaysInThisMonth{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return daysInLastMonth.length;
}



- (NSDate *)nextYearWithMonth:(int)month{

    NSDate *temDate = [self nextYear];
    
    NSDateComponents *com = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:temDate];
    com.month = month;
    
    NSDate *newDate = [[NSCalendar currentCalendar]dateFromComponents:com];
    return newDate;
}

- (NSDate *)lastMonth{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate*)nextMonth{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)nextYear{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)lastYear{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSInteger)currentWeekday
{
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps=[[NSDateComponents alloc]init];
    
    NSInteger unit= NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    
    comps=[calendar components:unit fromDate:self];
    
    return [comps weekday];
}


-(NSDate *)nextDay{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

-(NSDate *)nextDay:(NSInteger)count{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = +count;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)lastDay:(NSInteger)count{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -count;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
    
}
-(NSDate *)lastDay{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)getLocalDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: self];
    NSDate *localeDate = [self  dateByAddingTimeInterval: interval];
    return localeDate;
}

-(NSInteger)getDaysFromDate:(NSDate *)endDate
{
    //去掉时分秒信息
    NSCalendar *cal=[NSCalendar currentCalendar];
    
    NSDate *fromDate;
    NSDate *toDate;
    [cal rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:self];
    [cal rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [cal components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return dayComponents.day;
}

-(NSInteger)getDaysFromDateInMinute:(NSDate *)endDate{

    NSCalendar *cal=[NSCalendar currentCalendar];
    
    NSDate *fromDate;
    NSDate *toDate;
    [cal rangeOfUnit:NSCalendarUnitMinute startDate:&fromDate interval:NULL forDate:self];
    [cal rangeOfUnit:NSCalendarUnitMinute startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [cal components:NSCalendarUnitMinute fromDate:fromDate toDate:toDate options:0];
    
    NSInteger days =ceilf(dayComponents.minute/(24.f*60));
    
    if (days<1) {
        days = 1;
    }
    return days;
}

- (CGFloat)getHoursFromDate:(NSDate *)endDate{

    NSCalendar *cal=[NSCalendar currentCalendar];
    
    NSDate *fromDate;
    NSDate *toDate;
    [cal rangeOfUnit:NSCalendarUnitMinute startDate:&fromDate interval:NULL forDate:self];
    [cal rangeOfUnit:NSCalendarUnitMinute startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [cal components:NSCalendarUnitMinute fromDate:fromDate toDate:toDate options:0];
    
    CGFloat hour =dayComponents.minute/(60.f);
    return hour;
}

- (NSComparisonResult)compareDayToDate:(NSDate *)endDate{
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSComparisonResult result=[cal compareDate:self toDate:endDate toUnitGranularity:NSCalendarUnitDay];
    return result;
}

- (NSDate *)dateAfterHour:(NSInteger)hour{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = +hour;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

+ (BOOL)isDateToday:(NSDate *)date{
    BOOL isToday = [[NSCalendar currentCalendar]isDateInToday:date];
    return isToday;
}

- (NSInteger)getMonthIntervalFromDate:(NSDate *)endDate{
    NSCalendar *cal=[NSCalendar currentCalendar];
    
    NSDate *fromDate;
    NSDate *toDate;
    [cal rangeOfUnit:NSCalendarUnitMonth startDate:&fromDate interval:NULL forDate:self];
    [cal rangeOfUnit:NSCalendarUnitMonth startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *monthComponents = [cal components:NSCalendarUnitMonth fromDate:fromDate toDate:toDate options:0];
    return monthComponents.month + 1 ;
}


@end
