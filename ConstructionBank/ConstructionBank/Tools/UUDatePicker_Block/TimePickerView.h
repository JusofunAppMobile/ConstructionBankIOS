//
//  TimePickerView.h
//  PollsCloud
//
//  Created by WangZhipeng on 16/11/14.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUDatePicker.h"



@protocol DatePickDelegate <NSObject>

@optional
-(void)chooseDate:(NSString *)date;

@end

@interface TimePickerView : UIView

@property(nonatomic,assign) id<DatePickDelegate> delegate;


/**
 开始日期
 */
@property(nonatomic,copy)NSString *startDateStr;

/**
 开始月份
 */
@property(nonatomic,copy)NSString *startMonth;

-(void)showPick;

@property (nonatomic, retain) NSDate * getDayDate;//当DateStyle = UUDateStyle_Day 获取某年某月多少天

@property (nonatomic, assign) DateStyle datePickerStyle;

@end
